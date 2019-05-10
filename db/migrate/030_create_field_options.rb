class CreateFieldOptions < ActiveRecord::Migration[5.0]

  def up
    create_table :field_options do |t|
      t.references :custom_field, foreign_key: true, null: false
      t.string :name, limit: 255
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :field_options, [:custom_field_id, :name], unique: true
    add_index :field_options, :position
  end

  def down
    drop_table :field_options
  end

end
