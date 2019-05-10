class Product < ApplicationRecord
  include PolymorphicIntegerType::Extensions

  belongs_to :user

  has_many :field_values, as: :entity, integer_type: true, dependent: :destroy

  has_attached_file :img, styles: { medium: '360x360>', thumb: '120x120>', tiny: '16x16>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :img, content_type: /\Aimage\/.*\z/

  validates :name, presence: true
  validates :desc, presence: true
  validates :user, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000_000 }

  scope :ordered, -> { order(:name) }

end
