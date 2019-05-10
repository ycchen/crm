class Note < ApplicationRecord

  belongs_to :contact, counter_cache: true
  belongs_to :user

  # validates :user, presence: true
  validates :contact, presence: true
  validates :note, presence: true, length: { maximum: 4096 }

  scope :ordered, -> { order(created_at: :desc) }

  def pretty_created_at
    c = self.created_at.nil? ? Time.now : self.created_at
    c.strftime(TS_FORMAT)
  end

end
