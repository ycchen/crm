class AddFollowupTypes < ActiveRecord::Migration[5.0]

  def up
    %w(Call Text Email Facebook Instagram Twitter Pinterest).each do |name|
      FollowupType.create(name: name)
    end
  end

  def down; end

end
