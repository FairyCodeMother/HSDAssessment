# db/migrate/xxxxxxxxxx_create_trips.rb
class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    # Drop the table if it already exists
    if ActiveRecord::Base.connection.table_exists?(:trips)
      drop_table :trips
    end

    create_table :trips, id: false do |t|
      t.string :trip_id, null: false, primary_key: true
      t.string :driver_id, null: false
      t.string :ride_id, null: false
      t.decimal :commute_duration, precision: 10, scale: 2
      t.decimal :commute_distance, precision: 10, scale: 2
      t.decimal :total_duration, precision: 10, scale: 2
      t.decimal :total_distance, precision: 10, scale: 2

      t.timestamps
    end

    add_foreign_key :trips, :drivers, column: :driver_id, primary_key: :driver_id
    add_foreign_key :trips, :rides, column: :ride_id, primary_key: :ride_id
  end
end
