require 'rails_helper'

RSpec.describe Provider, type: :model do

  describe 'validation' do
    let(:provider) { build(:provider) }

    it 'has a valid factory' do
      expect(provider.valid?).to be_truthy
    end

    it 'requires a name' do
      provider.name = nil
      expect(provider.valid?).to be_falsey
    end

    it 'name must be less than 256 chars' do
      provider.name = 'x' * 256
      expect(provider.valid?).to be_falsey
    end

    it 'requires a unique name' do
      provider.save!
      provider2 = build(:provider, name: provider.name)
      expect(provider2.valid?).to be_falsey
    end
  end

  describe '.find_or_create' do
    let!(:user) { create(:user) }
    let!(:provider) { create(:provider) }

    it 'returns an existing provider' do
      expect {
        expect(Provider.find_or_create(provider.name)).to eq(provider)
      }.to change { Provider.count }.by(0)
    end

    it 'returns a new provider' do
      expect {
        Provider.find_or_create('xyz')
      }.to change { Provider.count }.by(1)
    end
  end

  describe 'has_many users' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:provider) { create(:provider, users: [user1, user2]) }

    it 'has some users' do
      expect(provider.users.size).to eq(2)
      expect(provider.users.include?(user1)).to be_truthy
      expect(provider.users.include?(user2)).to be_truthy
    end

    it 'raises if dependent users exist' do
      expect {
        expect { provider.destroy }.to change { User.count }.by(0)
      }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end

end
