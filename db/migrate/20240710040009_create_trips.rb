# db/migrate/xxxxxxxxxx_create_trips.rb
class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :trips if table_exists?(:trips)

        create_table :trips, id: :string, primary_key: :id do |t|
          t.string :user_driver_id, null: false
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
        add_foreign_key :trips, :user_drivers, column: :user_driver_id, primary_key: :id
        add_foreign_key :trips, :rides, column: :ride_id, primary_key: :id
      end
    end
  end
end
