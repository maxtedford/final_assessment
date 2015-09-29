require 'rails_helper'

RSpec.describe Rider, type: :model do
  context "on creation" do
    
    let(:valid_attributes) { {
      name: "Rider McGee",
      email: "rider@mcgee.com",
      phone_number: 1234567890,
      password: "password"
    } }
    
    it "is valid" do
      valid_rider = Rider.create(valid_attributes)
      
      expect(valid_rider).to be_valid
    end
    
    it "is invalid without a name" do
      invalid_rider = Rider.create(
        email: "rider@mcgee.com",
        phone_number: 1234567890,
        password: "password"   
      )
      
      expect(invalid_rider).not_to be_valid
    end
    
    it "is invalid without an email" do
      invalid_rider = Rider.create(
        name: "Rider McGee",
        phone_number: 1234567890,
        password: "password"
      )
      
      expect(invalid_rider).not_to be_valid
    end
    
    it "is invalid without a phone number" do
      invalid_rider = Rider.create(
        name: "Rider McGee",
        email: "rider@mcgee.com",
        password: "password"
      )
      
      expect(invalid_rider).not_to be_valid
    end
    
    it "is invalid without a password" do
      invalid_rider = Rider.create(
        name: "Rider McGee",
        email: "rider@mcgee.com",
        phone_number: 1234567890
      )
      
      expect(invalid_rider).not_to be_valid
    end
  end
end
