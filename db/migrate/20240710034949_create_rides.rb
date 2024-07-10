# db/migrate/xxxxxxxxxx_create_rides.rb
class CreateRides < ActiveRecord::Migration[7.1]
  def change
    # Drop the table if it already exists
    if ActiveRecord::Base.connection.table_exists?(:rides)
      drop_table :rides
    end

    create_table :rides, id: false do |t|
      t.string :ride_id, null: false, primary_key: true
      t.string :pickup_address, limit: 255, null: false
      t.string :destination_address, limit: 255, null: false
      t.decimal :ride_duration, precision: 10, scale: 2, null: false
      t.decimal :ride_distance, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
