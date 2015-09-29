require 'rails_helper'

RSpec.describe "login" do
  context "upon selecting login as rider" do
    let(:create_rider) { Rider.create(
      name: "Rider McGee",
      email: "rider@mcgee.com",
      phone_number: 1234567890,
      password: "password"
    ) }

    before(:each) {
      create_rider
      visit root_path
      click_link "Login as Rider"
    }
    
    it "redirects the user to their login page" do
      expect(page).to have_field "session[email]"
      expect(page).to have_field "session[password]"
    end
  end

  context "upon selecting login as driver" do

    let(:create_driver) { 
      Driver.create!(
        name: "Driver McGee",
        email: "rider@mcgee.com",
        phone_number: 1234567890,
        password: "password",
        car_make: "Honda",
        car_model: "Civic",
        car_capacity: 3
    ) }
    
    before(:each) {
      create_driver
      visit root_path
      click_link "Login as Driver"
    }

    it "redirects the user to their login page" do
      expect(page).to have_field "session[email]"
      expect(page).to have_field "session[password]"
    end
    
    it "redirects the user to their dashboard upon login" do
      fill_in "session[email]", with: "rider@mcgee.com"
      fill_in "session[password]", with: "password"
      click_button "Login as Driver"
      
      expect(page).to have_content("Welcome, Driver McGee")
    end
  end
  
  context "logging out" do

    before(:each) {
      Rider.create!(name: "Rider McGee", email: "rider@mcgee.com", phone_number: 1234567890, password: "password")
      visit rider_login_path
      fill_in "session[email]", with: "rider@mcgee.com"
      fill_in "session[password]", with: "password"
      click_button "Login as Rider"
    }

    it "should have a logout link at the top" do
      expect(page).to have_link("Logout")
    end

    it "should redirect back to the root after logout" do
      click_link "Logout"

      expect(page).to have_content("Welcome to Goober")
      expect(current_path).to eq(root_path)
    end
  end
end
