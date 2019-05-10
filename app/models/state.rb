class State < ApplicationRecord

  has_many :contacts, dependent: :nullify

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :abbr, presence: true, length: { maximum: 255 }, uniqueness: true

end
