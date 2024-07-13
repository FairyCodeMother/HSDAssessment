# db/migrate/xxxxxxxxxx_create_rides.rb
class CreateRides < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :rides if table_exists?(:rides)

        create_table :rides, id: :string, primary_key: :id do |t|
          t.string :pickup_address, null: false
          t.string :destination_address, null: false
          t.decimal :ride_minutes, precision: 10, scale: 2, null: false
          t.decimal :ride_miles, precision: 10, scale: 2, null: false
          t.timestamps
        end

        add_index :rides, :id, unique: true
      end
    end
  end
end
