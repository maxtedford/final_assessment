class RidersController < ApplicationController
  
  def new
    @rider = Rider.new
  end
end
