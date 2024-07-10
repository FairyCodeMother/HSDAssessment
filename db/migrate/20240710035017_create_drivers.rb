# db/migrate/xxxxxxxxxx_create_drivers.rb
class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    # Drop the table if it already exists
    if ActiveRecord::Base.connection.table_exists?(:drivers)
      drop_table :drivers
    end

    create_table :drivers, id: false do |t|
      t.string :driver_id, null: false, primary_key: true
      t.string :name, limit: 255, null: false
      t.string :home_address, limit: 255, null: false

      t.timestamps
    end
  end
end
