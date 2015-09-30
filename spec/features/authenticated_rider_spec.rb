require 'rails_helper'

RSpec.describe "authenticated rider" do
  context "on the dashboard page" do
    
    let(:rider) { Rider.create(
      name: "Rider McGee",
      email: "rider@mcgee.com",
      phone_number: 1234567890,
      password: "password" 
    ) }
    
    let(:driver) { Driver.create(
      name: "Driver McGee",
      email: "driver@mcgee.com",
      phone_number: 1234567890,
      password: "password",
      car_make: "Honda",
      car_model: "Civic",
      car_capacity: 3                     
    ) }
    
    before(:each) {
      rider
      visit rider_login_path
      fill_in "session[email]", with: rider.email
      fill_in "session[password]", with: "password"
      click_button "Login as Rider"
    }
    
    it "should see a link to request a ride" do
      expect(page).to have_link "Request a Ride"
    end
    
    it "redirects to a form to request a ride upon clicking" do
      click_link "Request a Ride"
      
      expect(page).to have_field("ride[pickup_location]")
      expect(page).to have_field("ride[dropoff_location]")
      expect(page).to have_field("ride[number_of_passengers]")
    end
    
    it "creates a new ride when the rider submits" do
      VCR.use_cassette("create_new_ride") do
        ride_count = Ride.count
        click_link "Request a Ride"
        fill_in "ride[pickup_location]", with: "1505 Blake Street, Denver, CO"
        fill_in "ride[dropoff_location]", with: "2557 Dunkeld Place, Denver, CO"
        fill_in "ride[number_of_passengers]", with: 2
        click_button "Request Ride"

        expect(Ride.count).to eq(ride_count + 1)

        new_ride = Ride.last

        expect(page).to have_content("Welcome, Rider McGee")
        expect(new_ride.status).to eq("active")
        expect(new_ride.pickup_location).to eq("1505 Blake Street, Denver, CO")
        expect(new_ride.dropoff_location).to eq("2557 Dunkeld Place, Denver, CO")
        expect(new_ride.number_of_passengers).to eq(2)
        expect(new_ride.rider_id).to eq(rider.id)
        expect(page).to have_content("active")
      end
    end
    
    it "removes the request ride link when there's an active ride" do
      VCR.use_cassette("hide_request_ride_link") do
        click_link "Request a Ride"
        fill_in "ride[pickup_location]", with: "1505 Blake Street, Denver, CO"
        fill_in "ride[dropoff_location]", with: "2557 Dunkeld Place, Denver, CO"
        fill_in "ride[number_of_passengers]", with: 2
        click_button "Request Ride"

        expect(page).not_to have_link("Request a Ride")
      end
    end
    
    it "updates the status of the ride request once the ride status changes" do
      VCR.use_cassette("updates_ride_to_accepted") do
        driver

        click_link "Request a Ride"
        fill_in "ride[pickup_location]", with: "1505 Blake Street, Denver, CO"
        fill_in "ride[dropoff_location]", with: "2557 Dunkeld Place, Denver, CO"
        fill_in "ride[number_of_passengers]", with: 2
        click_button "Request Ride"

        ride = Ride.last
        ride.update_attributes(status: "accepted", driver_id: driver.id)

        visit rider_path(rider)

        expect(page).to have_content("accepted")
        expect(page).to have_content("Driver McGee")
        expect(page).to have_content("Honda Civic")
      end
    end
    
    it "updates the status for the rider from 'accepted' to 'picked up'" do
      VCR.use_cassette("updates_ride_to_picked_up") do
        driver

        click_link "Request a Ride"
        fill_in "ride[pickup_location]", with: "1505 Blake Street, Denver, CO"
        fill_in "ride[dropoff_location]", with: "2557 Dunkeld Place, Denver, CO"
        fill_in "ride[number_of_passengers]", with: 2
        click_button "Request Ride"

        ride = Ride.last
        ride.update_attributes(status: "picked up", driver_id: driver.id)

        visit rider_path(rider)

        expect(page).to have_content("picked up")
        expect(page).to have_content("Driver McGee")
        expect(page).to have_content("Honda Civic")
      end
    end
    
    it "updates the status from the rider from 'picked up' to 'complete'" do
      VCR.use_cassette("updates_ride_to_completed") do
        driver

        click_link "Request a Ride"
        fill_in "ride[pickup_location]", with: "1505 Blake Street, Denver, CO"
        fill_in "ride[dropoff_location]", with: "2557 Dunkeld Place, Denver, CO"
        fill_in "ride[number_of_passengers]", with: 2
        click_button "Request Ride"

        ride = Ride.last
        ride.update_attributes(status: "accepted", accepted_time: 20.minutes.ago, driver_id: driver.id)
        ride.update_attributes(status: "picked up", pickup_time: 15.minutes.ago, driver_id: driver.id)
        ride.update_attributes(status: "completed", dropoff_time: DateTime.now, driver_id: driver.id)

        visit rider_path(rider)

        expect(page).not_to have_content("picked up")
        expect(page).not_to have_content("Honda Civic")
        expect(page).to have_link("Request a Ride")
      end
    end
    
    it "has a section for all the rider's completed rides" do
      expect(page).to have_content("Completed Rides")
    end
    
    it "shows all completed rides in the completed rides section" do
      VCR.use_cassette("updates_ride_to_completed") do
        driver

        ride = Ride.create(
          pickup_location: "1505 Blake Street, Denver, CO",
          dropoff_location: "2557 Dunkeld Place, Denver, CO",
          number_of_passengers: 2,
          status: "completed",
          rider_id: rider.id,
          driver_id: driver.id,
          created_at: 20.minutes.ago,
          accepted_time: 15.minutes.ago,
          pickup_time: 10.minutes.ago,
          dropoff_time: Time.now,
          time_in_minutes: GoogleDirections.new("1505 Blake Street, Denver, CO", "2557 Dunkeld Place, Denver, CO").drive_time_in_minutes,
          mileage: GoogleDirections.new("1505 Blake Street, Denver, CO", "2557 Dunkeld Place, Denver, CO").distance_in_miles
        )

        within("#completed-rides") do
          expect(page).not_to have_content("1505 Blake Street, Denver, CO")
        end

        visit rider_path(rider)

        within("#completed-rides") do
          expect(page).to have_content("Rider McGee")
          expect(page).to have_content("Driver McGee")
          expect(page).to have_content("1505 Blake Street, Denver, CO")
          expect(page).to have_content("2557 Dunkeld Place, Denver, CO")
          expect(page).to have_content(ride.cost)
        end
      end
    end
    
    it "displays the estimated duration and distance for the trip" do
      VCR.use_cassette("display_distance_and_duration") do
        driver

        Ride.create(
          pickup_location: "1505 Blake Street, Denver, CO",
          dropoff_location: "2557 Dunkeld Place, Denver, CO",
          number_of_passengers: 2,
          status: "active",
          rider_id: rider.id,
          driver_id: driver.id,
          created_at: 20.minutes.ago,
          accepted_time: 15.minutes.ago,
          pickup_time: 10.minutes.ago,
          dropoff_time: Time.now,
          time_in_minutes: GoogleDirections.new("1505 Blake Street, Denver, CO", "2557 Dunkeld Place, Denver, CO").drive_time_in_minutes,
          mileage: GoogleDirections.new("1505 Blake Street, Denver, CO", "2557 Dunkeld Place, Denver, CO").distance_in_miles
        )

        visit rider_path(rider)

        within("#active-rides") do
          expect(page).to have_content("Ride Duration: 6 minutes")
          expect(page).to have_content("Ride Distance: 1 mile")
        end
      end
    end
  end
end
