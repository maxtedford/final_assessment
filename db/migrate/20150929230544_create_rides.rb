class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :pickup_location
      t.string :dropoff_location
      t.integer :number_of_passengers
      t.string :status, default: "active"
      t.timestamp :requested_time
      t.timestamp :accepted_time
      t.timestamp :pickup_time
      t.timestamp :dropoff_time
      t.references :rider, index: true, foreign_key: true
      t.references :driver, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
