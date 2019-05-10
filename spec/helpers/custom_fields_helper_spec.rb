require 'rails_helper'

RSpec.describe CustomFieldsHelper, type: :helper do

  let(:contact) { create(:contact) }

  describe '#checkbox_checked' do
    let(:custom_field) { create(:custom_field, :checkbox) }

    it 'returns true' do
      create(:field_value, entity: contact, custom_field: custom_field)
      expect(helper.checkbox_checked(contact, custom_field)).to be_truthy
    end

    it 'returns false' do
      expect(helper.checkbox_checked(contact, custom_field)).to be_falsey
    end
  end

  describe '#option_checkbox_checked' do
    let(:custom_field) { create(:custom_field, :checkboxes) }
    let(:field_option) { create(:field_option, custom_field: custom_field) }

    it 'existing field value returns true' do
      create(:field_value, custom_field: custom_field, entity: contact, value: field_option.id)
      expect(helper.option_checkbox_checked(contact, custom_field, field_option, {})).to be_truthy
    end

    it 'params with field value returns true' do
      params = { custom_fields: { custom_field.id.to_s => [field_option.id.to_s] } }
      expect(helper.option_checkbox_checked(contact, custom_field, field_option, params)).to be_truthy
    end

    it 'returns false' do
      expect(helper.option_checkbox_checked(contact, custom_field, field_option, {})).to be_falsey
    end
  end

  describe '#select_option_selected' do
    let(:custom_field) { create(:custom_field, :select) }
    let(:field_option) { create(:field_option, custom_field: custom_field) }

    it 'existing field value returns true' do
      create(:field_value, custom_field: custom_field, entity: contact, value: field_option.id)
      expect(helper.select_option_selected(contact, custom_field, field_option, {})).to be_truthy
    end

    it 'params with field value returns true' do
      params = { custom_fields: { custom_field.id.to_s => field_option.id.to_s } }
      expect(helper.select_option_selected(contact, custom_field, field_option, params)).to be_truthy
    end

    it 'returns false' do
      expect(helper.select_option_selected(contact, custom_field, field_option, {})).to be_falsey
    end
  end
end
