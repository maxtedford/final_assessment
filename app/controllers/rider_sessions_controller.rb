class RiderSessionsController < ApplicationController
  
  def new
  end
  
  def create
    @rider = Rider.find_by(email: params[:session][:email])
    if @rider && @rider.authenticate(params[:session][:password])
      session[:rider_id] = @rider.id
      redirect_to @rider
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
