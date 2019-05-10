
require 'bcrypt'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || 'is not valid')
    end
  end
end

class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  include BCrypt

  belongs_to :provider, optional: true

  has_many :contacts, dependent: :destroy
  has_many :followups, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :custom_fields, dependent: :destroy

  validates :email, presence: true, uniqueness: true, email: true, length: { maximum: 64 }
  validates :fname, presence: true, length: { maximum: 32 }
  validates :lname, presence: true, length: { maximum: 32 }

  def self.find_or_create_facebook(token)
    d = token.info
    p = Provider.find_or_create(token.provider)
    u = User.find_by(email: d[:email])
    if u
      u.update_attributes(provider: p, uid: token.uid)
      return u
    end
    d[:first_name], d[:last_name] = User.parse_fullname(d[:name])
    User.create_oauth_user(d, p, token.uid)
  end

  def self.create_oauth_user(d, p, uid)
    u = User.new(email: d[:email], fname: d[:first_name], lname: d[:last_name],
                 provider: p, uid: uid, password: Devise.friendly_token[0, 20])
    u.skip_confirmation!
    u.save
    u
  end

  def self.parse_fullname(name)
    return ['', ''] unless name
    return [name, ''] unless name.include?(' ')
    names = name.split
    return [names[0], ''] unless names.size > 1
    [names[0], names[-1]]
  end

  def self.find_or_create_google_oauth2(token)
    d = token.info
    p = Provider.find_or_create(token.provider)
    u = User.find_by(email: d[:email])
    return User.create_oauth_user(d, p, token.uid) unless u
    u.update_attributes(provider: p, uid: token.uid)
    u
  end

  def fullname
    "#{fname} #{lname}"
  end

  def incomplete_followups_count
    followups.incomplete.count
  end

end
