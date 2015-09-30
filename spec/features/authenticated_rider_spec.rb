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
      ride_count = Ride.count
      click_link "Request a Ride"
      fill_in "ride[pickup_location]", with: "123 fake street"
      fill_in "ride[dropoff_location]", with: "123 faux street"
      fill_in "ride[number_of_passengers]", with: 2
      click_button "Request Ride"
      
      expect(Ride.count).to eq(ride_count + 1)
      
      new_ride = Ride.last
      
      expect(page).to have_content("Welcome, Rider McGee")
      expect(new_ride.status).to eq("active")
      expect(new_ride.pickup_location).to eq("123 fake street")
      expect(new_ride.dropoff_location).to eq("123 faux street")
      expect(new_ride.number_of_passengers).to eq(2)
      expect(new_ride.rider_id).to eq(rider.id)
      expect(page).to have_content("#{new_ride.created_at}")
      expect(page).to have_content("active")
    end
    
    it "removes the request ride link when there's an active ride" do
      click_link "Request a Ride"
      fill_in "ride[pickup_location]", with: "123 fake street"
      fill_in "ride[dropoff_location]", with: "123 faux street"
      fill_in "ride[number_of_passengers]", with: 2
      click_button "Request Ride"
      
      expect(page).not_to have_link("Request a Ride")
    end
    
    it "updates the status of the ride request once the ride status changes" do
      driver
      
      click_link "Request a Ride"
      fill_in "ride[pickup_location]", with: "123 fake street"
      fill_in "ride[dropoff_location]", with: "123 faux street"
      fill_in "ride[number_of_passengers]", with: 2
      click_button "Request Ride"
      
      ride = Ride.last
      ride.update_attributes(status: "accepted", driver_id: driver.id)
      
      visit rider_path(rider)
      
      expect(page).to have_content("accepted")
      expect(page).to have_content("Driver McGee")
      expect(page).to have_content("Honda Civic")
    end
    
    it "updates the status for the rider from 'accepted' to 'picked up'" do
      driver

      click_link "Request a Ride"
      fill_in "ride[pickup_location]", with: "123 fake street"
      fill_in "ride[dropoff_location]", with: "123 faux street"
      fill_in "ride[number_of_passengers]", with: 2
      click_button "Request Ride"

      ride = Ride.last
      ride.update_attributes(status: "picked up", driver_id: driver.id)

      visit rider_path(rider)

      expect(page).to have_content("picked up")
      expect(page).to have_content("Driver McGee")
      expect(page).to have_content("Honda Civic")
    end
    
    it "updates the status from the rider from 'picked up' to 'complete'" do
      driver

      click_link "Request a Ride"
      fill_in "ride[pickup_location]", with: "123 fake street"
      fill_in "ride[dropoff_location]", with: "123 faux street"
      fill_in "ride[number_of_passengers]", with: 2
      click_button "Request Ride"

      ride = Ride.last
      ride.update_attributes(status: "completed", driver_id: driver.id)
      
      visit rider_path(rider)

      expect(page).not_to have_content("picked up")
      expect(page).not_to have_content("Honda Civic")
      expect(page).to have_link("Request a Ride")
    end
    
    it "has a section for all the rider's completed rides" do
      expect(page).to have_content("Completed Rides")
    end
    
    it "shows all completed rides in the completed rides section" do
      driver
      
      ride = Ride.create(
        pickup_location: "123 fake street",
        dropoff_location: "123 faux street",
        number_of_passengers: 2,
        status: "completed",
        rider_id: rider.id,
        driver_id: driver.id,
        created_at: Time.now,
        accepted_time: Time.now,
        pickup_time: Time.now,
        dropoff_time: Time.now
      )
      
      within("#completed-rides") do
        expect(page).not_to have_content("123 fake street")
      end

      visit rider_path(rider)

      within("#completed-rides") do
        expect(page).to have_content("Rider McGee")
        expect(page).to have_content("Driver McGee")
        expect(page).to have_content("123 fake street")
        expect(page).to have_content("123 faux street")
        expect(page).to have_content(ride.created_at)
        expect(page).to have_content(ride.accepted_time)
        expect(page).to have_content(ride.pickup_time)
        expect(page).to have_content(ride.dropoff_time)
      end
    end
  end
end
