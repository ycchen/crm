class DropCounterCache < ActiveRecord::Migration[5.0]

  def up
    remove_column :users, :followups_count
  end

  def down; end

end
