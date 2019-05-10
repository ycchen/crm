class Followup < ApplicationRecord
  include PolymorphicIntegerType::Extensions

  belongs_to :followup_type
  belongs_to :user
  belongs_to :contact, counter_cache: true

  has_many :field_values, as: :entity, integer_type: true, dependent: :destroy

  validates :followup_type, presence: true
  validates :user, presence: true
  validates :contact, presence: true
  validates :note, presence: true, length: { maximum: 4096 }
  validates :when, presence: true

  scope :incomplete, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
  scope :ordered, -> { order(when: :asc) }
  scope :ordered_rev, -> { ordered.reverse_order }

  after_save :update_last_contacted

  def pretty_when
    w = self.when ? self.when : Time.current
    w.strftime(TS_FORMAT)
  end

  def update_last_contacted
    return unless completed
    lc = contact.last_contacted
    return if lc && lc > self.when
    contact.update_attribute(:last_contacted, self.when)
  end

end
