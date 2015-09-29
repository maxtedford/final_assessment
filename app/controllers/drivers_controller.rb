class DriversController < ApplicationController
  
  def new
    @driver = Driver.new
  end
end
