class RidersController < ApplicationController
  
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
  
  def strong_rider_params
    params.require(:rider).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end
end
