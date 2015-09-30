require 'rails_helper'

RSpec.describe Driver, type: :model do
  context "is created" do
    
    let(:valid_attributes) { {
      name: "Driver McGee",
      email: "driver@mcgee.com",
      phone_number: 1234567890,
      password: "password",
      car_make: "Honda",
      car_model: "Civic",
      car_capacity: 3
    } }
    
    it "is valid" do
      valid_driver = Driver.create(valid_attributes)
      
      expect(valid_driver).to be_valid
    end
    
    it "is invalid without a name" do
      invalid_driver = Driver.create(
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: 3
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "is invalid without an email" do
      invalid_driver = Driver.create(
        name: "Driver McGee",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: 3
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "is invalid without a phone number" do
      invalid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: 3
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "is invalid without a password" do
      invalid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: 3
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "is invalid without a car make" do
      invalid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_model: "Civic",
        car_capacity: 3
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "is invalid without a car model" do
      invalid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_capacity: 3
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "is invalid without a car capacity" do
      invalid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
      )
      
      expect(invalid_driver).not_to be_valid
    end
    
    it "must have a car capacity in integer format" do
      valid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: 3
      )
      invalid_driver = Driver.create(
        name: "Driver McGee",
        email: "driver@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: "A"
      )
      
      expect(valid_driver).to be_valid
      expect(invalid_driver).not_to be_valid
    end
  end
end
