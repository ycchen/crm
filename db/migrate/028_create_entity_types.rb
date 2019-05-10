class CreateEntityTypes < ActiveRecord::Migration[5.2]

  def up
    create_table :entity_types do |t|
      t.string :name, limit: 32
    end
    add_index :entity_types, :name, unique: true
  end

  def down
    drop_table :entity_types
  end

end
