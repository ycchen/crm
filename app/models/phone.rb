class Phone < ApplicationRecord

  belongs_to :contact
  belongs_to :phone_type

  validates :contact, presence: true
  validates :phone_type, presence: true
  validates :number, presence: true, length: { minimum: 7, maximum: 11 }

end
