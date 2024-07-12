# db/migrate/xxxxxxxxxx_create_trips.rb
class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    # Drop the table if it already exists
    if ActiveRecord::Base.connection.table_exists?(:trips)
      drop_table :trips
    end

    create_table :trips, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :driver_id, null: false
      t.string :ride_id, null: false
      t.decimal :commute_minutes, precision: 10, scale: 2
      t.decimal :commute_miles, precision: 10, scale: 2
      t.decimal :total_minutes, precision: 10, scale: 2
      t.decimal :total_hours, precision: 10, scale: 2
      t.decimal :total_miles, precision: 10, scale: 2
      t.decimal :earnings, precision: 10, scale: 2

      t.timestamps
    end

    add_index :trips, :id, unique: true
    add_foreign_key :trips, :drivers, column: :driver_id, primary_key: :id
    add_foreign_key :trips, :rides, column: :ride_id, primary_key: :id
  end
end
