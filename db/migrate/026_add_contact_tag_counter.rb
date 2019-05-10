class AddContactTagCounter < ActiveRecord::Migration[5.0]

  def up
    add_column :tags, :contact_tags_count, :integer, default: 0
    add_index :tags, :contact_tags_count
  end

  def down
    remove_index :tags, :contact_tags_count
    remove_column :tags, :contact_tags_count
  end

end
