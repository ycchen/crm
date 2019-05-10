class AddEntityTypes < ActiveRecord::Migration[5.0]
  def up
    %w(Contact Product Followup Sale).sort.each do |name|
      next if EntityType.find_by(name: name)
      EntityType.create(name: name)
    end
  end

  def down; end
end
