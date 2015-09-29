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
end
