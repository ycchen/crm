class CreatePhoneTypes < ActiveRecord::Migration[5.2]

  def change
    create_table :phone_types do |t|
      t.string :name, limit: 16
    end
    add_index :phone_types, :name, unique: true
  end

end
