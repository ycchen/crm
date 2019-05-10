class AddAttachmentImgToProducts < ActiveRecord::Migration

  def up
    change_table :products do |t|
      t.attachment :img
    end
  end

  def down
    remove_attachment :products, :img
  end

end
