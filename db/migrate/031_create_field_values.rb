class CreateFieldValues < ActiveRecord::Migration[5.2]

  def up
    create_table :field_values do |t|
      t.references :custom_field, foreign_key: true, null: false
      t.integer :entity_id, null: false
      t.integer :entity_type, null: false
      t.text :value
      t.timestamps
    end
    add_index :field_values, [:custom_field_id, :entity_id, :entity_type], unique: true, name: 'cf_id_e_id_et_uniq_idx'
  end

  def down
    drop_table :field_values
  end

end
