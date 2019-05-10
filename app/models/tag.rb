class Tag < ApplicationRecord

  belongs_to :user

  has_many :contact_tags, dependent: :destroy
  has_many :contacts, through: :contact_tags

  validates :user, presence: true
  validates :name, presence: true, uniqueness: true

  scope :active, -> { where('contact_tags_count > 0') }
  scope :ordered, -> { order(name: :asc) }

  before_validation :cleanup_name

  def to_s
    name
  end

  def self.get_or_create(user, name)
    name = name.downcase
    tag = Tag.find_by(user: user, name: name)
    tag = Tag.create!(user: user, name: name) unless tag
    tag
  end

  private

  def cleanup_name
    n = name.blank? ? '' : name
    self.name = n.downcase
                 .tr('_', '-')
                 .gsub(/[^-a-z0-9\ ]/, '')
                 .gsub(/[-]{2,}/, '-')
                 .gsub(/^-/, '')
                 .gsub(/-$/, '')
  end

end
