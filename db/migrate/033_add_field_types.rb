class AddFieldTypes < ActiveRecord::Migration[5.2]
  def up
    %w(text textarea checkbox checkboxes select radio date time datetime number color range email url).sort.each do |name|
      FieldType.create!(name: name)
    end
  end

  def down
    FieldType.destroy_all
  end
end
