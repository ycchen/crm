class CreateSaleItems < ActiveRecord::Migration[5.0]

  def change
    create_table :sale_items do |t|
      t.references :sale, foreign_key: true
      t.references :product, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.timestamps
    end
  end

end
