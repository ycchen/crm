class Sale < ApplicationRecord
  include PolymorphicIntegerType::Extensions

  belongs_to :user
  belongs_to :contact

  has_many :sale_items, dependent: :destroy
  has_many :field_values, as: :entity, integer_type: true, dependent: :destroy

  validates :user, presence: true
  validates :contact, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  def total
    result = 0
    sale_items.each do |i|
      result += (i.quantity * i.price)
    end
    result
  end

  def pretty_created_at
    created_at.strftime(DT_FORMAT)
  end

end
