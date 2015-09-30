class Rider < ActiveRecord::Base
  has_secure_password
  has_many :rides
  has_many :drivers, through: :rides
  
  validates :name,
    presence: true
  validates :email,
    presence: true,
    uniqueness: true
  validates :phone_number,
    presence: true
  validates :password,
    presence: true
  # validate :email_uniqueness
  
  def active_rides
    rides.where.not(status: "completed")
  end

  private

  def email_uniqueness
    errors.add(:base, "Cannot use the same email as another user--must be unique") if Driver.all.each{ |driver| self.email == driver.email}
  end
end
