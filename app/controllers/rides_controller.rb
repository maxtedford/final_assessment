class RidesController < ApplicationController
  
  def new
    @ride = Ride.new
  end
  
  def create
    @ride = Ride.new(strong_ride_params)
    @ride.rider_id = current_rider.id
    if @ride.save
      flash[:message] = "You've just requested a ride!"
      redirect_to rider_path(current_rider)
    else
      flash.now[:error] = @ride.errors.full_messages.join(", ")
    end
  end
  
  def update
    ride = Ride.find(params[:id])
    RideUpdater.new(ride, current_driver).update
    redirect_to driver_path(current_driver)
  end
  
  private
  
  def strong_ride_params
    params.require(:ride).permit(
      :pickup_location,
      :dropoff_location,
      :number_of_passengers,
      :status,
      :requested_time,
      :accepted_time,
      :pickup_time,
      :dropoff_time,
      :rider_id,
      :driver_id
    )
  end
end
