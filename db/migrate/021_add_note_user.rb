class AddNoteUser < ActiveRecord::Migration[5.2]
  def up
    add_column :notes, :user_id, :integer
    Note.all.each do |n|
      n.update_attribute(:user_id, n.contact.user_id)
    end
    change_column :notes, :user_id, :integer, null: false
  end

  def down
    remove_column :notes, :user_id, :integer
  end
end
