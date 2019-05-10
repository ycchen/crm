require 'rails_helper'

RSpec.describe FieldOption, type: :model do

  describe 'validation' do
    let(:field_option) { build(:field_option) }

    it 'has a valid factory' do
      expect(field_option.valid?).to be_truthy
    end

    it 'requires a custom field' do
      field_option.custom_field = nil
      expect(field_option.valid?).to be_falsey
    end

    it 'requires a name' do
      field_option.name = nil
      expect(field_option.valid?).to be_falsey
    end

    it 'requires a unique name' do
      field_option.save!
      field_option2 = build(:field_option, custom_field: field_option.custom_field, name: field_option.name)
      expect(field_option2.valid?).to be_falsey
    end
  end

  describe 'belongs to custom field' do
    let(:custom_field) { create(:custom_field) }
    let(:field_option) { create(:field_option, custom_field: custom_field) }

    it 'must have a custom field' do
      expect(field_option.custom_field).to eq(custom_field)
    end
  end

  describe 'acts as list' do
    let(:field_option1) { build(:field_option) }
    let(:field_option2) { build(:field_option) }
    let!(:field_option3) { create(:field_option) }
    let(:custom_field) { create(:custom_field) }

    it 'returns field options scoped by custom field' do
      custom_field.field_options << field_option1
      custom_field.field_options << field_option2
      expect(custom_field.field_options.size).to eq(2)
      expect(field_option1.position).to eq(1)
      expect(field_option2.position).to eq(2)
    end
  end

  describe 'scope' do
    let(:field_option1) { build(:field_option) }
    let(:field_option2) { build(:field_option) }
    let(:custom_field) { create(:custom_field) }

    describe '.ordered' do
      it 'returns field options scoped by custom field' do
        custom_field.field_options << field_option1
        custom_field.field_options << field_option2
        expect(custom_field.field_options.ordered).to eq([field_option1, field_option2])
      end
    end
  end
end
