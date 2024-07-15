# db/migrate/xxxxxxxxxx_create_chauffeurs.rb
class CreateChauffeurs < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :chauffeurs if table_exists?(:chauffeurs)

        create_table :chauffeurs, id: :string, primary_key: :id do |t|
          t.string :home_address, null: false
          t.timestamps
        end

        add_index :chauffeurs, :id, unique: true
      end
    end
  end
end
