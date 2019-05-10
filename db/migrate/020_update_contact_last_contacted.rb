class UpdateContactLastContacted < ActiveRecord::Migration[5.0]
  def up
    Followup.completed.each do |f|
      c = f.contact
      lc = c.last_contacted
      if lc.nil? || lc < f.when
        c.update_attribute(:last_contacted, f.when)
      end
    end
  end

  def down; end
end
