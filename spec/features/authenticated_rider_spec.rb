require 'rails_helper'

RSpec.describe "authenticated rider" do
  context "on the dashboard page" do
    
    let(:rider) { Rider.create(
      name: "Rider McGee",
      email: "rider@mcgee.com",
      phone_number: 1234567890,
      password: "password" 
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
  end
end
