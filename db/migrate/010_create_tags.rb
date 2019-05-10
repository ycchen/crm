class CreateTags < ActiveRecord::Migration[5.2]

  def change
    create_table :tags do |t|
      t.integer :user_id, null: false
      t.string :name, null: false, limit: 32
    end
    add_index :tags, [:user_id, :name], unique: true
  end

end
