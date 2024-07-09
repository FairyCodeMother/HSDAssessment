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
