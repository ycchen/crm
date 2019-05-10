class FieldType < ApplicationRecord

  has_many :fields, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 32 }, uniqueness: true

  scope :ordered, -> { order(:name) }

end
