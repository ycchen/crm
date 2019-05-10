class CreateFollowupTypes < ActiveRecord::Migration[5.0]

  def change
    create_table :followup_types do |t|
      t.string :name, limit: 16
    end
    add_index :followup_types, :name, unique: true
  end

end
