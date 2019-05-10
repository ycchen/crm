require 'rails_helper'

RSpec.describe FieldType, type: :model do

  describe 'validation' do
    let(:field_type) { build(:field_type) }

    it 'has a valid factory' do
      expect(field_type.valid?).to be_truthy
    end

    it 'requires a name' do
      field_type.name = nil
      expect(field_type.valid?).to be_falsey
    end

    it 'name must be less than 33 chars' do
      field_type.name = 'x' * 33
      expect(field_type.valid?).to be_falsey
    end

    it 'requires a unique name' do
      field_type.save!
      field_type2 = build(:field_type, name: field_type.name)
      expect(field_type2.valid?).to be_falsey
    end
  end

  describe 'scope' do
    let!(:field_type1) { create(:field_type, name: 'a') }
    let!(:field_type2) { create(:field_type, name: 'b') }

    describe '.ordered' do
      it 'returns field types ordered by name' do
        expect(FieldType.ordered).to eq([field_type1, field_type2])
      end
    end
  end

end
