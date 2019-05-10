class CreateProviders < ActiveRecord::Migration[5.2]

  def change
    create_table :providers do |t|
      t.string :name, limit: 255, null: false
      t.timestamps
    end
  end

end
