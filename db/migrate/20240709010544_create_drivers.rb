# db/migrate/xxxxxxxxxx_create_drivers.rb
class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers do |t|
      t.integer :driver_id
      t.string :home_address

      t.timestamps
    end
    add_index :drivers, :driver_id
  end
end

# docker-compose run web rails generate migration CreateDrivers driver_id:integer:index home_address:string