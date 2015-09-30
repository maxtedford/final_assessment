class RideEstimator
attr_reader :ride, :origin, :destination
  
  def initialize(ride, origin, destination)
    @ride = ride
    @origin = origin
    @destination = destination
  end
  
  def estimate
    ride.time_in_minutes = GoogleDirections.new(origin, destination).drive_time_in_minutes
    ride.mileage = GoogleDirections.new(origin, destination).distance_in_miles
  end
end
