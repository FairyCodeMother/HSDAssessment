# db/migrate/xxxxxxxxxx_create_drivers.rb
class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers do |t|
      t.string :driver_id, null: false
      t.string :home_address, null: false

      t.timestamps
    end

    add_index :drivers, :driver_id, unique: true
  end
end
