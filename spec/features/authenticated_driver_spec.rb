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
    end
    
    it "only displays rides that have a passenger count less than or equal to the driver's capacity" do
      expect(page).to have_content("123 fake street")
      expect(page).not_to have_content("789 fake street")
    end
  end
end
