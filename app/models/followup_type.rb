class FollowupType < ApplicationRecord

  has_many :followups, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 16 }, uniqueness: true

  scope :ordered, -> { order(:name) }

end
