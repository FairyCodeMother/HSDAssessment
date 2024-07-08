# db/migrate/xxxxxxxxxx_create_rides.rb
class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.string :ride_id, null: false
      t.string :start_address, null: false
      t.string :destination_address, null: false
      t.float :ride_distance_miles
      t.float :ride_duration_hours

      t.timestamps
    end

    add_index :rides, :ride_id, unique: true
  end
end
