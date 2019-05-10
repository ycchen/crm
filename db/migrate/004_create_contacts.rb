class CreateContacts < ActiveRecord::Migration[5.2]

  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :address2
      t.string :city
      t.references :state, foreign_key: true
      t.string :zip
      t.timestamps
    end
  end

end
