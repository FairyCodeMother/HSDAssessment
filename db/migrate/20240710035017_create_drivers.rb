# db/migrate/xxxxxxxxxx_create_drivers.rb
class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    # Drop the table if it already exists
    if ActiveRecord::Base.connection.table_exists?(:drivers)
      drop_table :drivers
    end

    create_table :drivers, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :home_address, null: false

      t.timestamps
    end

    add_index :drivers, :id, unique: true
  end
end
