class CreateNotes < ActiveRecord::Migration[5.0]

  def change
    create_table :notes do |t|
      t.integer :contact_id, null: false
      t.text :note, null: false, limit: 4096
      t.timestamps
    end
    add_index :notes, :contact_id
    add_index :notes, :created_at
  end

end
