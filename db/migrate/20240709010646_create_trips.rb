# db/migrate/xxxxxxxxxx_create_trips.rb
class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.decimal :commute_duration, precision: 10, scale: 2
      t.decimal :commute_distance, precision: 10, scale: 2
      t.decimal :total_duration, precision: 10, scale: 2
      t.decimal :total_distance, precision: 10, scale: 2

      t.timestamps
    end
  end
end

# docker-compose run web rails generate migration CreateTrips ride:references driver:references 'commute_duration:decimal{10,2}' 'commute_distance:decimal{10,2}' 'total_duration:decimal{10,2}' 'total_distance:decimal{10,2}'