class CreateFieldTypes < ActiveRecord::Migration[5.0]

  def up
    create_table :field_types do |t|
      t.string :name, limit: 32
    end
    add_index :field_types, :name, unique: true
  end

  def down
    drop_table :field_types
  end

end
