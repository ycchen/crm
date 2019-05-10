class CustomField < ApplicationRecord

  belongs_to :user
  belongs_to :entity_type
  acts_as_list scope: [:user_id, :entity_type_id]

  belongs_to :field_type

  has_many :field_options, dependent: :destroy

  validates :entity_type, presence: true
  validates :field_type, presence: true
  validates :user, presence: true
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: [:user, :entity_type] }

  scope :ordered, -> { order(:entity_type_id, :position) }
  scope :for_entity, ->(entity_type) { where(entity_type: entity_type) }

  def can_have_options?
    %w(select checkboxes radio).include?(field_type.name)
  end

end
