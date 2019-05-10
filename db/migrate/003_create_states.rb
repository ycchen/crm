class CreateStates < ActiveRecord::Migration[5.0]
  
  def change
    create_table :states do |t|
      t.string :name
      t.string :abbr
    end
    add_index :states, :name, unique: true
    add_index :states, :abbr, unique: true
  end

end
