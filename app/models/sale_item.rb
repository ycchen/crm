class SaleItem < ApplicationRecord

  belongs_to :sale
  belongs_to :product

  validates :sale, presence: true
  validates :product, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000_000 }

  scope :ordered, -> { order(:id) }

end
