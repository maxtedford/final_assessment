class Ride < ActiveRecord::Base
  belongs_to :rider
  belongs_to :driver
  
  validates :pickup_location,
    presence: true
  validates :dropoff_location,
    presence: true
  validates :number_of_passengers,
    presence: true
  validates :status,
    presence: true
  validates :rider_id,
    presence: true
  
  def driver_name
    Driver.find(self.driver_id).name if self.driver_id
  end
  
  def rider_name
    Rider.find(self.rider_id).name if self.rider_id
  end
  
  def cost
    (((self.dropoff_time - self.pickup_time) / 180 ) * 2 ).round(2)
  end
end
