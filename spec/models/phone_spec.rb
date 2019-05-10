require 'rails_helper'

RSpec.describe Phone, type: :model do

  describe 'validation' do
    let(:phone) { build(:phone) }

    it 'has a valid factory' do
      expect(phone.valid?).to be_truthy
    end

    it 'requires a contact' do
      phone.contact = nil
      expect(phone.valid?).to be_falsey
    end

    it 'requires a phone_type' do
      phone.phone_type = nil
      expect(phone.valid?).to be_falsey
    end

    it 'requires a valid number' do
      phone.number = '1' * 6
      expect(phone.valid?).to be_falsey
    end

    it 'requires a valid number' do
      phone.number = '1' * 12
      expect(phone.valid?).to be_falsey
    end
  end
end
