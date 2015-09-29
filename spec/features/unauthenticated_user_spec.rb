require 'rails_helper'

RSpec.describe "unauthenticated user", type: :feature do
  context "views the root page" do
    
    before(:each) { visit root_path }
    
    it "will see a welcome page" do
      expect(page).to have_content("Welcome to Goober!")
    end
    
    it "will have a rider sign up link" do
      expect(page).to have_link("Rider")
    end
    
    it "will have a driver sign up link" do
      expect(page).to have_link("Driver")
    end
    
    it "will have a login link" do
      expect(page).to have_link("Login")
    end
  end
  
  context "upon selecting 'rider'" do
    
    before(:each) {
      visit root_path
      click_link "Rider"
    }
    
    it "shows the user a form for signing up as a rider" do
      expect(page).to have_field("rider[name]")
      expect(page).to have_field("rider[email]")
      expect(page).to have_field("rider[phone_number]")
      expect(page).to have_field("rider[password]")
      expect(page).to have_field("rider[password_confirmation]")
    end
  end
  
  context "upon selecting 'driver'" do
    
    before(:each) {
      visit root_path
      click_link "Driver"
    }
    
    it "shows the user a form for signing up as a driver" do
      expect(page).to have_field("driver[name]")
      expect(page).to have_field("driver[email]")
      expect(page).to have_field("driver[phone_number]")
      expect(page).to have_field("driver[password]")
      expect(page).to have_field("driver[password_confirmation]")
      expect(page).to have_field("driver[car_make]")
      expect(page).to have_field("driver[car_model]")
      expect(page).to have_field("driver[car_capacity]")
    end
  end
end
