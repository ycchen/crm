require 'rails_helper'

RSpec.describe PhoneType, type: :model do

  describe 'validation' do
    let(:phone_type) { build(:phone_type) }

    it 'has a valid factory' do
      expect(phone_type.valid?).to be_truthy
    end

    it 'requires a name' do
      phone_type.name = nil
      expect(phone_type.valid?).to be_falsey
    end

    it 'name must be less than 17 chars' do
      phone_type.name = 'x' * 17
      expect(phone_type.valid?).to be_falsey
    end

    it 'requires a unique name' do
      phone_type.save!
      phone_type2 = build(:phone_type, name: phone_type.name)
      expect(phone_type2.valid?).to be_falsey
    end
  end

  describe 'scope' do
    let!(:phone_type1) { create(:phone_type, name: 'a') }
    let!(:phone_type2) { create(:phone_type, name: 'b') }

    describe '.ordered' do
      it 'returns field types ordered by name' do
        expect(PhoneType.ordered).to eq([phone_type1, phone_type2])
      end
    end
  end

end
