class EntityType < ApplicationRecord

  has_many :custom_fields, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 32 }, uniqueness: true

  scope :ordered, -> { order(:name) }

  class << self
    def contact
      EntityType.find_by(name: 'Contact')
    end

    def followup
      EntityType.find_by(name: 'Followup')
    end

    def product
      EntityType.find_by(name: 'Product')
    end

    def sale
      EntityType.find_by(name: 'Sale')
    end
  end

end
