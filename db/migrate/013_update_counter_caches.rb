class UpdateCounterCaches < ActiveRecord::Migration[5.2]

  def up
    User.find_each { |u| User.reset_counters(u.id, :contacts) }
  end

  def down; end

end
