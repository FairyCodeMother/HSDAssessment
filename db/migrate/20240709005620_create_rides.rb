# db/migrate/xxxxxxxxxx_create_rides.rb
class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.integer :ride_id
      t.string :starting_address
      t.string :destination_address
      t.decimal :ride_duration, precision: 10, scale: 2
      t.decimal :ride_distance, precision: 10, scale: 2

      t.timestamps
    end
    add_index :rides, :ride_id
  end
end

# docker-compose run web rails generate migration CreateRides ride_id:integer:index starting_address:string destination_address:string 'ride_duration:decimal{10,2}' 'ride_distance:decimal{10,2}'