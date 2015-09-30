require 'rails_helper'

RSpec.describe "authenticated driver" do
  context "dashboard" do
    
    let(:rider1) { Rider.create(
      name: "Rider McGee",
      email: "rider@mcgee.com",
      phone_number: 1234567890,
      password: "password",
    ) }
    
    let(:rider2) { Rider.create(
      name: "Rider2 McGee",
      email: "rider2@mcgee.com",
      phone_number: 1234567890,
      password: "password",
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
    
    let(:create_rides) {
      Ride.create(
        pickup_location: "123 fake street",
        dropoff_location: "123 faux street",
        number_of_passengers: 2,
        status: "active",
        rider_id: rider1.id,
        driver_id: nil
      )
      Ride.create(
        pickup_location: "456 fake street",
        dropoff_location: "456 faux street",
        number_of_passengers: 4,
        status: "accepted",
        rider_id: rider2.id,
        driver_id: nil
      )
      Ride.create(
        pickup_location: "789 fake street",
        dropoff_location: "789 faux street",
        number_of_passengers: 4,
        status: "active",
        rider_id: rider2.id,
        driver_id: nil
      )
    }
    
    before(:each) {
      rider1
      rider2
      driver
      create_rides
      visit driver_login_path
      fill_in "session[email]", with: driver.email
      fill_in "session[password]", with: "password"
      click_button "Login as Driver"
    }
    
    it "has a list for all available rides (those with a status of 'active')" do
      expect(page).to have_content("Available Rides")
      expect(page).to have_content("123 fake street")
      expect(page).to have_content("2")
      expect(page).not_to have_content("456 fake street")
      expect(page).not_to have_content("4")
    end
    
    it "has a link next to each ride for the driver to claim it" do
      expect(page).to have_link("Claim Ride")
      expect(page).not_to have_content("Current Ride:")
    end
    
    it "only displays rides that have a passenger count less than or equal to the driver's capacity" do
      expect(page).to have_content("123 fake street")
      expect(page).not_to have_content("789 fake street")
    end
    
    it "updates the status from active to accepted" do
      click_link("Claim Ride")
      
      expect(page).to have_content("Current Ride:")
      expect(page).to have_content("123 fake street")
      expect(page).to have_content("accepted")
      expect(page).not_to have_content("Available Rides")
    end
    
    it "has a link next to the current ride to 'pick up rider'" do
      click_link("Claim Ride")
      
      expect(page).to have_link("Pick up Rider")
    end
    
    it "will update the status to 'picked up' once clicked" do
      click_link("Claim Ride")
      click_link("Pick up Rider")

      expect(page).not_to have_link("Pick up Rider")
      expect(page).to have_content("picked up")
      
      ride = Ride.find_by(pickup_location: "123 fake street")
      
      expect(ride.pickup_time).not_to be_nil
    end
    
    it "has a link next to the current ride to 'complete' the ride" do
      click_link("Claim Ride")
      click_link("Pick up Rider")
      
      expect(page).to have_link("Complete Ride")
    end
    
    it "will update the status to 'completed' once clicked" do
      click_link("Claim Ride")
      click_link("Pick up Rider")
      click_link("Complete Ride")

      expect(page).not_to have_link("Complete Ride")
      expect(page).to have_content("Available Rides")

      ride = Ride.find_by(pickup_location: "123 fake street")

      expect(ride.dropoff_time).not_to be_nil
    end
  end
end
