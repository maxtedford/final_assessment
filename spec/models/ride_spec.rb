require 'rails_helper'

RSpec.describe Ride, type: :model do
  context "on creation" do
    
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
    )}
    
    let(:valid_attributes) { {
      pickup_location: "1505 Blake Street, Denver, CO",
      dropoff_location: "2557 Dunkeld Place, Denver, CO",
      number_of_passengers: 2,
      status: "active",
      rider_id: rider.id,
      driver_id: driver.id,
      requested_time: nil,
      accepted_time: nil,
      pickup_time: 15.minutes.ago,
      dropoff_time: DateTime.now,
      time_in_minutes: GoogleDirections.new("1505 Blake Street, Denver, CO", "2557 Dunkeld Place, Denver, CO").drive_time_in_minutes,
      mileage: GoogleDirections.new("1505 Blake Street, Denver, CO", "2557 Dunkeld Place, Denver, CO").distance_in_miles
    } }
    
    it "is valid" do
      valid_ride = Ride.new(valid_attributes)
      
      expect(valid_ride).to be_valid
    end
    
    it "is invalid without a pickup location" do
      invalid_ride = Ride.new(
        dropoff_location: "123 faux street",
        number_of_passengers: 2,
        status: "active",
        rider_id: rider.id,
        driver_id: nil
      )
      
      expect(invalid_ride).not_to be_valid
    end
    
    it "is invalid without a dropoff location" do
      invalid_ride = Ride.new(
        pickup_location: "123 fake street",
        number_of_passengers: 2,
        status: "active",
        rider_id: rider.id,
        driver_id: nil
      )
      
      expect(invalid_ride).not_to be_valid
    end
    
    it "is invalid without a number of passengers" do
      invalid_ride = Ride.new(
        pickup_location: "123 fake street",
        dropoff_location: "123 faux street",
        status: "active",
        rider_id: rider.id,
        driver_id: nil
      )
      
      expect(invalid_ride).not_to be_valid
    end
    
    it "is invalid without a rider id" do
      invalid_ride = Ride.new(
        pickup_location: "123 fake street",
        dropoff_location: "123 faux street",
        number_of_passengers: 2,
        status: "active",
        driver_id: nil
      )
      
      expect(invalid_ride).not_to be_valid
    end
    
    it "defaults to a status of active" do
      valid_ride = Ride.create(
        pickup_location: "123 fake street",
        dropoff_location: "123 faux street",
        number_of_passengers: 2,
        rider_id: rider.id,
        driver_id: nil
      )
      
      expect(valid_ride.status).to eq("active")
    end
    
    it "can calculate its cost" do
      rider
      driver
      ride = Ride.create(valid_attributes)
      
      expect(ride.cost).to eq(10)
    end
    
    it "can create a geocoded pickup location" do
      rider
      driver
      ride = Ride.create(valid_attributes)
      
      expect(ride.time_in_minutes).to eq("6")
      expect(ride.mileage).to eq("1")
    end
  end
end
