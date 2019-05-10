class CreatePhones < ActiveRecord::Migration[5.2]

  def change
    create_table :phones do |t|
      t.references :contact, foreign_key: true
      t.references :phone_type, foreign_key: true
      t.string :number, limit: 11
      t.timestamps
    end
  end

end
