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
    
    it "will have a rider login link" do
      expect(page).to have_link("Login as Rider")
    end
    
    it "will have a driver login link" do
      expect(page).to have_link("Login as Driver")
    end
  end
  
  context "upon selecting 'rider'" do
    
    let(:rider) { Rider.create(
      name: "Rider McGee",
      email: "rider@mcgee.com",
      phone_number: 1234567890,
      password: "password"
    ) }
    
    it "shows the user a form for signing up as a rider" do
      visit root_path
      click_link "Rider"
      
      expect(page).to have_field("rider[name]")
      expect(page).to have_field("rider[email]")
      expect(page).to have_field("rider[phone_number]")
      expect(page).to have_field("rider[password]")
      expect(page).to have_field("rider[password_confirmation]")
    end
    
    it "redirects the user to their dashboard once they sign up" do
      visit root_path
      click_link "Rider"
      
      fill_in "rider[name]", with: "Rider McGee"
      fill_in "rider[email]", with: "rider@mcgee.com"
      fill_in "rider[phone_number]", with: 1234567890
      fill_in "rider[password]", with: "password"
      fill_in "rider[password_confirmation]", with: "password"
      click_button "Sign Up"
      
      expect(page).to have_content("Rider McGee")
    end
    
    it "throws an error if a new rider tries to use a duplicate email address" do
      rider
      visit root_path
      click_link "Rider"

      fill_in "rider[name]", with: "Rider McGee"
      fill_in "rider[email]", with: "rider@mcgee.com"
      fill_in "rider[phone_number]", with: 1234567890
      fill_in "rider[password]", with: "password"
      fill_in "rider[password_confirmation]", with: "password"
      click_button "Sign Up"
      
      expect(current_path).to eq(riders_path)
      expect(page).to have_content("Email has already been taken")
    end
    
    it "throws an error if a new rider's password confirmation is inconsistent" do
      visit root_path
      click_link "Rider"

      fill_in "rider[name]", with: "Rider McGee"
      fill_in "rider[email]", with: "rider@mcgee.com"
      fill_in "rider[phone_number]", with: 1234567890
      fill_in "rider[password]", with: "password"
      fill_in "rider[password_confirmation]", with: "spazzword"
      click_button "Sign Up"
      
      expect(current_path).to eq(riders_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
    
    it "redirects the rider to their dashboard once they login" do
      rider
      visit rider_login_path
      fill_in "session[email]", with: rider.email
      fill_in "session[password]", with: "password"
      click_button "Login as Rider"
      
      expect(page).to have_content("Welcome, #{rider.name}")
    end
    
    it "will throw an error if a rider doesn't authenticate" do
      visit rider_login_path
      fill_in "session[email]", with: rider.email
      fill_in "session[password]", with: "spazzword"
      click_button "Login as Rider"

      expect(current_path).to eq(rider_login_path)
      expect(page).to have_content("Invalid login")
    end
  end
  
  context "upon selecting 'driver'" do
    
    let(:driver) { Driver.create(
      name: "Driver McGee",
      email: "driver@mcgee.com",
      phone_number: 1234567890,
      password: "password",
      car_make: "Honda",
      car_model: "Civic",
      car_capacity: 3                     
    ) }
    
    it "shows the user a form for signing up as a driver" do
      visit root_path
      click_link "Driver"
      
      expect(page).to have_field("driver[name]")
      expect(page).to have_field("driver[email]")
      expect(page).to have_field("driver[phone_number]")
      expect(page).to have_field("driver[password]")
      expect(page).to have_field("driver[password_confirmation]")
      expect(page).to have_field("driver[car_make]")
      expect(page).to have_field("driver[car_model]")
      expect(page).to have_field("driver[car_capacity]")
    end
    
    it "redirects the user to their dashboard once they sign up" do
      visit root_path
      click_link "Driver"
      
      fill_in "driver[name]", with: "Driver McGee"
      fill_in "driver[email]", with: "driver@mcgee.com"
      fill_in "driver[phone_number]", with: 1234567890
      fill_in "driver[password]", with: "password"
      fill_in "driver[password_confirmation]", with: "password"
      fill_in "driver[car_make]", with: "Honda"
      fill_in "driver[car_model]", with: "Civic"
      fill_in "driver[car_capacity]", with: 3
      click_button "Sign Up"
      
      expect(page).to have_content("Welcome, Driver McGee")
    end
    
    it "throws an error if a new driver tries to use a duplicate email address" do
      driver
      visit root_path
      click_link "Driver"

      fill_in "driver[name]", with: "Driver McGee"
      fill_in "driver[email]", with: "driver@mcgee.com"
      fill_in "driver[phone_number]", with: 1234567890
      fill_in "driver[password]", with: "password"
      fill_in "driver[password_confirmation]", with: "password"
      fill_in "driver[car_make]", with: "Honda"
      fill_in "driver[car_model]", with: "Civic"
      fill_in "driver[car_capacity]", with: 3
      click_button "Sign Up"
      
      expect(current_path).to eq(drivers_path)
      expect(page).to have_content("Email has already been taken")
    end

    it "throws an error if a new driver's password confirmation is inconsistent" do
      visit root_path
      click_link "Driver"

      fill_in "driver[name]", with: "Driver McGee"
      fill_in "driver[email]", with: "driver@mcgee.com"
      fill_in "driver[phone_number]", with: 1234567890
      fill_in "driver[password]", with: "password"
      fill_in "driver[password_confirmation]", with: "spazzword"
      fill_in "driver[car_make]", with: "Honda"
      fill_in "driver[car_model]", with: "Civic"
      fill_in "driver[car_capacity]", with: 3
      click_button "Sign Up"

      expect(current_path).to eq(drivers_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
    
    it "redirects the user to their dashboard once they login" do
      driver
      visit driver_login_path
      fill_in "session[email]", with: driver.email
      fill_in "session[password]", with: "password"
      click_button "Login as Driver"
      
      expect(page).to have_content("Welcome, #{driver.name}")
    end
    
    it "will throw an error if a driver doesn't authenticate" do
      driver
      visit driver_login_path
      fill_in "session[email]", with: driver.email
      fill_in "session[password]", with: "spazzword"
      click_button "Login as Driver"
      
      expect(current_path).to eq(driver_login_path)
      expect(page).to have_content("Invalid login")
    end
  end
end
