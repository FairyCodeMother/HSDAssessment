# db/migrate/xxxxxxxxxx_create_rides.rb
class CreateRides < ActiveRecord::Migration[7.1]
  def change
    # Drop the table if it already exists
    if ActiveRecord::Base.connection.table_exists?(:rides)
      drop_table :rides
    end

    create_table :rides, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :pickup_address, null: false
      t.string :destination_address, null: false
      t.decimal :ride_minutes, precision: 10, scale: 2, null: false
      t.decimal :ride_miles, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :rides, :id, unique: true
  end
end
