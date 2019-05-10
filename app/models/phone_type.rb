class PhoneType < ApplicationRecord

  has_many :phones, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 16 }, uniqueness: true

  scope :ordered, -> { order(:name) }

end
