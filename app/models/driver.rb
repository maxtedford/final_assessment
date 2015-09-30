class Driver < ActiveRecord::Base
  has_secure_password
  has_many :rides
  has_many :riders, through: :rides
  
  validates :name,
    presence: true
  validates :email,
    presence: true,
    uniqueness: true
  validates :phone_number,
    presence: true
  validates :password,
    presence: true, on: :create
  validates :car_make,
    presence: true
  validates :car_model,
    presence: true
  validates :car_capacity,
    presence: true,
    numericality: { with: /\A[+-]?\d+\Z/ }
  validate :email_uniqueness

  def current_ride
    rides.where.not(status: "completed").last
  end
  
  def completed_rides
    rides.where(status: "completed")
  end
  
  private

  def email_uniqueness
    errors.add(:base, "Cannot use the same email as another user--must be unique") if Rider.any?{ |rider| rider.email == self.email }
  end
end
