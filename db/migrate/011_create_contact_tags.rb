class CreateContactTags < ActiveRecord::Migration[5.0]
  
  def change
    create_table :contact_tags do |t|
      t.integer :contact_id, null: false
      t.integer :tag_id, null: false
    end
    add_index :contact_tags, [:contact_id, :tag_id], unique: true
  end

end
