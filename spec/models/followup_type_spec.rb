require 'rails_helper'

RSpec.describe FollowupType, type: :model do

  describe 'validation' do
    let(:followup_type) { build(:followup_type) }

    it 'has a valid factory' do
      expect(followup_type.valid?).to be_truthy
    end

    it 'requires a name' do
      followup_type.name = nil
      expect(followup_type.valid?).to be_falsey
    end

    it 'name must be less than 17 chars' do
      followup_type.name = 'x' * 17
      expect(followup_type.valid?).to be_falsey
    end

    it 'requires a unique name' do
      followup_type.save!
      followup_type2 = build(:followup_type, name: followup_type.name)
      expect(followup_type2.valid?).to be_falsey
    end
  end

  describe 'scope' do
    let!(:followup_type1) { create(:followup_type, name: 'a') }
    let!(:followup_type2) { create(:followup_type, name: 'b') }

    describe '.ordered' do
      it 'returns field types ordered by name' do
        expect(FollowupType.ordered).to eq([followup_type1, followup_type2])
      end
    end
  end

end
