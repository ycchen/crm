class ContactTag < ApplicationRecord

  belongs_to :contact
  belongs_to :tag, counter_cache: true

  validates :contact, presence: true
  validates :tag, presence: true, uniqueness: { scope: :contact }

end
