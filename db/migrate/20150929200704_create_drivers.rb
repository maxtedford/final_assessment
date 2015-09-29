class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :email
      t.integer :phone_number
      t.string :password_digest
      t.string :car_make
      t.string :car_model
      t.integer :car_capacity

      t.timestamps null: false
    end
  end
end
