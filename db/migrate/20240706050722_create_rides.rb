class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.string :start_address
      t.string :destination_address
      t.references :driver, null: false, foreign_key: true
      t.float :commute_distance
      t.float :commute_duration
      t.float :ride_distance
      t.float :ride_duration
      t.float :earnings

      t.timestamps
    end
  end
end
