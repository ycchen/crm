class DropCounterCache < ActiveRecord::Migration[5.2]

  def up
    remove_column :users, :followups_count
  end

  def down; end

end
