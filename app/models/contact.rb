require 'uri'
require 'time'

class Contact < ApplicationRecord
  include PolymorphicIntegerType::Extensions

  belongs_to :state, optional: true
  belongs_to :user, counter_cache: true

  has_many :phones, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :followups, dependent: :destroy
  has_many :incomplete_followups, -> { where(completed: false) }, class_name: 'Followup'
  has_many :sales, dependent: :destroy
  has_many :field_values, as: :entity, integer_type: true, dependent: :destroy

  has_many :contact_tags, dependent: :destroy
  has_many :tags, through: :contact_tags
  attr_accessor :tags_string

  scope :ordered, -> { order(last_contacted: :asc) }
  scope :with_tags, -> { includes(:tags) }

  validates :user,       presence: true
  validates :first_name, presence: true
  validates :last_name,  presence: true

  after_save :update_tags

  def sorted_tags
    tags.sort_by(&:contact_tags_count).reverse
  end

  def get_tags_string
    tags.map(&:name).join(',')
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def incomplete_followups_count
    followups.incomplete.count
  end

  def pretty_last_contacted
    return 'Never' unless last_contacted
    last_contacted.strftime(TS_FORMAT)
  end

  private

  def update_tags
    ts = tags_string.nil? ? [] : tags_string.split(',')
    ts.each do |t|
      tag = Tag.get_or_create(user, t)
      contact_tag = contact_tags.find_by(tag: tag)
      contact_tags.create!(tag: tag) unless contact_tag
    end
    contact_tags.each do |contact_tag|
      contact_tag.destroy unless ts.include?(contact_tag.tag.name)
    end
  end

end
