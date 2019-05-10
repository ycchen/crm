require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    let(:user) { build(:user) }

    it 'has a valid factory' do
      expect(user.valid?).to be_truthy
    end

    it 'requires an email' do
      user.email = nil
      expect(user.valid?).to be_falsey
    end

    it 'requires a first name' do
      user.fname = nil
      expect(user.valid?).to be_falsey
    end

    it 'requires a last name' do
      user.lname = nil
      expect(user.valid?).to be_falsey
    end
  end

  describe 'provider' do
    let(:provider) { create(:provider) }
    let(:user) { build(:user, provider: provider) }

    it 'can be present' do
      expect(user).to be_valid
    end

    it 'can be absent' do
      user.provider = nil
      expect(user).to be_valid
    end
  end

  describe 'user' do
    let(:user) { create(:user, contacts: [build(:contact)], followups: [build(:followup)]) }

    it 'has many contacts' do
      expect(user.contacts.first.class).to eq(Contact)
    end

    it 'has many followups' do
      expect(user.followups.first.class).to eq(Followup)
    end
  end

  describe '#incomplete_followups_count' do
    let(:user) { create(:user, followups: [build(:followup)]) }

    it 'returns incomplete followups count' do
      user.followups << create(:followup, :completed)
      expect(user.incomplete_followups_count).to eq(1)
    end
  end

  describe '#fullname' do
    let(:user) { create(:user) }

    it 'returns fullname' do
      expected = "#{user.fname} #{user.lname}"
      expect(user.fullname).to eq(expected)
    end
  end

  describe '.parse_fullname' do
    it 'returns first and last names' do
      expect(User.parse_fullname(nil)).to eq(['', ''])
      expect(User.parse_fullname('')).to eq(['', ''])
      expect(User.parse_fullname('a')).to eq(['a', ''])
      expect(User.parse_fullname('a b')).to eq(%w(a b))
      expect(User.parse_fullname('a b c')).to eq(%w(a c))
    end
  end

  describe '.create_oath_user' do
    let(:provider) { create(:provider) }
    let(:d) { { email: 'a@b.com', first_name: 'a', last_name: 'b' } }
    let(:uid) { 123 }
    let(:user) { User.create_oauth_user(d, p, uid) }

    it 'creates an oath user' do
      expect(user.valid?).to be_truthy
    end

    it 'skips confirmation' do
      expect(user.confirmed_at).to_not be_nil
    end
  end

  describe '.find_or_create_facebook' do
    let(:token) { OmniAuth::AuthHash.new(provider: 'Facebook', uid: 123, info: { email: 'a@b.com', name: 'a b' }) }

    it 'creates a Facebook user' do
      expect {
        user = User.find_or_create_facebook(token)
        expect(user.valid?).to be_truthy
      }.to change{ User.count }.by(1)
    end

    it 'finds a Facebook user' do
      create(:user, email: 'a@b.com')
      expect {
        user = User.find_or_create_facebook(token)
        expect(user).to_not be_nil
        expect(user.email).to eq('a@b.com')
      }.to change{ User.count }.by(0)
    end
  end

  describe '.find_or_create_google' do
    let(:token) { OmniAuth::AuthHash.new(provider: 'Google', uid: 123, info: { email: 'a@b.com', first_name: 'a', last_name: 'b' }) }

    it 'creates a Google user' do
      expect {
        user = User.find_or_create_google_oauth2(token)
        expect(user.valid?).to be_truthy
      }.to change{ User.count }.by(1)
    end

    it 'finds a Google user' do
      create(:user, email: 'a@b.com')
      expect {
        user = User.find_or_create_google_oauth2(token)
        expect(user).to_not be_nil
        expect(user.email).to eq('a@b.com')
      }.to change{ User.count }.by(0)
    end
  end
end
