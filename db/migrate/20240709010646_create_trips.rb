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
