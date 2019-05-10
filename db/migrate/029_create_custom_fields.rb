class CreateCustomFields < ActiveRecord::Migration[5.0]

  def up
    create_table :custom_fields do |t|
      t.references :user, foreign_key: true, null: false
      t.references :entity_type, foreign_key: true, null: false
      t.references :field_type, foreign_key: true, null: false
      t.string :name, limit: 255, null: false
      t.integer :position, null: false, default: 0
      t.boolean :required, null: false, default: false
      t.timestamps
    end
    add_index :custom_fields, [:user_id, :entity_type_id, :name], unique: true
    add_index :custom_fields, :position
  end

  def down
    drop_table :custom_fields
  end

end
