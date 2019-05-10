class FieldOption < ApplicationRecord

  belongs_to :custom_field
  acts_as_list scope: :custom_field

  validates :custom_field, presence: true
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :custom_field }

  scope :ordered, -> { order(:position) }

end
