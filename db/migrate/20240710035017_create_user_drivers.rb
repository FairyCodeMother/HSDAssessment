# db/migrate/xxxxxxxxxx_create_user_drivers.rb
class CreateUserDrivers < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :user_drivers if table_exists?(:user_drivers)

        create_table :user_drivers, id: :string, primary_key: :id do |t|
          t.string :home_address, null: false
          t.timestamps
        end

        add_index :user_drivers, :id, unique: true
      end
    end
  end
end
