class AddUserFields < ActiveRecord::Migration[5.0]

  def up
    add_column :users, :time_zone, :string, length: 255, null: false, default: 'Central Time (US & Canada)'
    add_column :users, :provider_id, :integer
    add_column :users, :uid, :string, limit: 255
    add_index :users, [:provider_id, :uid], unique: true
  end

  def down
    remove_column :users, :time_zone
    remove_column :users, :provider_id
    remove_column :users, :uid
  end

end
