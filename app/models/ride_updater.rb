class RideUpdater
attr_reader :ride, :driver
  
  def initialize(ride, driver)
    @ride = ride
    @driver = driver
  end
  
  def update
    if ride.status == "active"
      ride.driver_id = driver.id
      ride.status = "accepted"
      ride.accepted_time = DateTime.now
      ride.save
    elsif ride.status == "accepted"
      ride.status = "picked up"
      ride.pickup_time = DateTime.now
      ride.save
    else
      ride.status = "completed"
      ride.dropoff_time = DateTime.now
      ride.save
    end
  end
end
