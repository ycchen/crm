class AddCounterCaches < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :notes_count, :integer, null: false, default: 0
    add_column :contacts, :followups_count, :integer, null: false, default: 0
    add_column :users, :followups_count, :integer, null: false, default: 0
    add_column :users, :contacts_count, :integer, null: false, default: 0
  end
end
