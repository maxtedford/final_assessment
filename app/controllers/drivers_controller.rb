class DriversController < ApplicationController
  
  def new
    @driver = Driver.new
  end
  
  def create
    @driver = Driver.new(strong_driver_params)
    if @driver.save
      flash[:message] = "Successfully created account for #{@driver.name} as a driver"
      session[:driver_id] = @driver.id
      redirect_to @driver
    else
      flash.now[:error] = @driver.errors.full_messages.join(", ")
      render :new
    end
  end
  
  def show
  end
  
  private
  
  def strong_driver_params
    params.require(:driver).permit(:name, :email, :phone_number, :password, :car_make, :car_model, :car_capacity)
  end
end
