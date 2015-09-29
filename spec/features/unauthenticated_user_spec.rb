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
    
    it "redirects the user to their dashboard once they sign up" do
      fill_in "rider[name]", with: "Rider McGee"
      fill_in "rider[email]", with: "rider@mcgee.com"
      fill_in "rider[phone_number]", with: 1234567890
      fill_in "rider[password]", with: "password"
      fill_in "rider[password_confirmation]", with: "password"
      click_button "Create Rider"
      
      expect(page).to have_content("Rider McGee")
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
    
    it "redirecst the user to their dashboard once they sign up" do
      fill_in "driver[name]", with: "Driver McGee"
      fill_in "driver[email]", with: "rider@mcgee.com"
      fill_in "driver[phone_number]", with: 1234567890
      fill_in "driver[password]", with: "password"
      fill_in "driver[password_confirmation]", with: "password"
      fill_in "driver[car_make]", with: "Honda"
      fill_in "driver[car_model]", with: "Civic"
      fill_in "driver[car_capacity]", with: 3
      click_button "Create Driver"
      
      expect(page).to have_content("Welcome, Driver McGee")
    end
  end
end
