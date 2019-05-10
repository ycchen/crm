class AddContactLastContacted < ActiveRecord::Migration[5.2]
  def up
    add_column :contacts, :last_contacted, :timestamp
  end

  def down
    remove_column :contacts, :last_contacted
  end
end
