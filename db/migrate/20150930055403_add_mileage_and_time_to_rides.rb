class AddMileageAndTimeToRides < ActiveRecord::Migration
  def change
    add_column :rides, :mileage, :string
    add_column :rides, :time_in_minutes, :string
  end
end
