class CreateFollowups < ActiveRecord::Migration[5.2]

  def change
    create_table :followups do |t|
      t.integer :user_id, null: false
      t.integer :contact_id, null: false
      t.integer :followup_type_id, null: false
      t.boolean :completed, null: false, default: false
      t.text :note, limit: 4096
      t.timestamp :when, null: false
      t.timestamps
    end
    add_index :followups, :user_id
    add_index :followups, :contact_id
    add_index :followups, :followup_type_id
    add_index :followups, :completed
    add_index :followups, :when
  end

end
