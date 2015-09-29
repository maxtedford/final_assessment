class DriverSessionsController < ApplicationController

  def new
  end

  def create
    @driver = Driver.find_by(email: params[:session][:email])
    if @driver && @driver.authenticate(params[:session][:password])
      session[:driver_id] = @driver.id
      redirect_to @driver
    else
      flash[:message] = "Invalid login"
      render :new
    end
  end
  
  def destroy
    session.clear
    redirect_to root_path
  end
end
