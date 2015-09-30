class RidersController < ApplicationController
  before_action :check_current_rider, only: [:show]
  
  def new
    @rider = Rider.new
  end
  
  def create
    @rider = Rider.new(strong_rider_params)
    if @rider.save
      flash[:message] = "Successfully created account for #{@rider.name} as a rider!"
      session[:rider_id] = @rider.id
      redirect_to @rider
    else
      flash.now[:error] = @rider.errors.full_messages.join(", ")
      render :new
    end
  end
  
  def show
    
  end
  
  private
  
  def check_current_rider
    redirect_to root_path if !current_rider
  end
  
  def strong_rider_params
    params.require(:rider).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end
end
