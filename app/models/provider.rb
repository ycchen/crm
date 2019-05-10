class Provider < ApplicationRecord

  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: true

  def self.find_or_create(name)
    p = Provider.find_by(name: name)
    return p if p
    Provider.create!(name: name)
  end

end
