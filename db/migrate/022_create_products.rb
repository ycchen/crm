class CreateProducts < ActiveRecord::Migration[5.2]

  def change
    create_table :products do |t|
      t.references :user, foreign_key: true
      t.string :name, limit: 255
      t.text :desc
      t.decimal :price, precision: 10, scale: 2
      t.timestamps
    end
  end

end
