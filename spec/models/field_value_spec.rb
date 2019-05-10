require 'rails_helper'

RSpec.describe FieldValue, type: :model do
  describe 'validation' do
    let(:field_value) { build(:field_value) }

    it 'has a valid factory' do
      expect(field_value.valid?).to be_truthy
    end

    it 'requires a custom field' do
      field_value.custom_field = nil
      expect(field_value.valid?).to be_falsey
    end

    it 'requires an entity' do
      field_value.entity = nil
      expect(field_value.valid?).to be_falsey
    end

    it 'value has a maximum size' do
      field_value.value = 'x' * 1025
      expect(field_value.valid?).to be_falsey
    end
  end

  describe '.update_values' do
    let(:entity) { create(:contact) }
    let(:custom_field) { create(:custom_field, :text) }
    let(:custom_field_id) { custom_field.id.to_s }
    let(:user) { create(:user, custom_fields: [custom_field]) }
    let(:params) { {} }

    it 'no params returns no errors' do
      expect(FieldValue.update_values(user, entity, params)).to eq({})
    end

    it 'valid params creates a field value' do
      params = { custom_field_id => '1' }
      expect {
        expect(FieldValue.update_values(user, entity, params)).to eq({})
      }.to change { FieldValue.count }.by(1)
    end

    it 'valid params creates a required field value' do
      custom_field.required = true
      params = { custom_field_id => '1' }
      expect {
        expect(FieldValue.update_values(user, entity, params)).to eq({})
      }.to change { FieldValue.count }.by(1)
    end

    it 'missing value creates an error' do
      custom_field.required = true
      params = { custom_field_id => '' }
      expect {
        expect(FieldValue.update_values(user, entity, params)).to eq({"_#{custom_field_id}".to_sym => 'required field'})
      }.to change { FieldValue.count }.by(0)
    end

    it 'invalid value creates a field value error' do
      params = { custom_field_id => 'x' * 1025 }
      expect {
        expect(FieldValue.update_values(user, entity, params)).to eq({"_#{custom_field_id}".to_sym => 'is too long (maximum is 1024 characters)'})
      }.to change { FieldValue.count }.by(0)
    end
  end

  describe '.value_for' do
    let(:entity) { create(:contact) }
    let(:custom_field) { create(:custom_field) }

    it 'returns a value' do
      create(:field_value, entity: entity, custom_field: custom_field)
      expect(FieldValue.value_for(entity, custom_field)).to eq('1')
    end

    it 'returns an empty string when a value does not exist' do
      expect(FieldValue.value_for(entity, custom_field)).to eq('')
    end
  end

  describe '.save_value' do
    let(:entity) { create(:contact) }
    let(:custom_field) { create(:custom_field) }
    let(:value1) { '42' }
    let(:value2) { '17' }

    it 'creates a new custom field value for an entity' do
      expect {
        FieldValue.save_value(entity, custom_field, value1)
      }.to change{ FieldValue.count }.by(1)
      expect(FieldValue.first.value).to eq(value1)
    end

    it 'updates an existing custom field value for an entity' do
      create(:field_value, entity: entity, custom_field: custom_field, value: value1)
      expect {
        FieldValue.save_value(entity, custom_field, value2)
      }.to change{ FieldValue.count }.by(0)
      expect(FieldValue.first.value).to eq(value2)
    end
  end

  describe '.value_select' do
    let(:field_option) { create(:field_option) }
    let!(:custom_field) { create(:custom_field, :select, field_options: [field_option]) }

    it 'returns select field option id' do
      expect(FieldValue.value_select(custom_field, field_option.id, {})).to eq([field_option.id, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_select(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_select(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_radio' do
    let(:field_option) { create(:field_option) }
    let!(:custom_field) { create(:custom_field, :radio, field_options: [field_option]) }

    it 'returns select field option id' do
      expect(FieldValue.value_select(custom_field, field_option.id, {})).to eq([field_option.id, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_select(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_select(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_checkboxes' do
    let(:field_option1) { create(:field_option) }
    let(:field_option2) { create(:field_option) }
    let!(:custom_field) { create(:custom_field, :checkboxes, field_options: [field_option1, field_option2]) }

    it 'returns select field option id' do
      expect(FieldValue.value_checkboxes(custom_field, [[field_option1.id, 1], [field_option2.id, 1]], {})).to eq(["#{field_option1.id},#{field_option2.id}", {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_checkboxes(custom_field, [[0, 0]], {})).to eq(['', {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_checkboxes(custom_field, [[0, 0]], {})).to eq(['', { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_url' do
    let!(:custom_field) { create(:custom_field, :url) }
    let(:url) { 'http://crm12.com' }

    it 'returns url value' do
      expect(FieldValue.value_url(custom_field, url, {})).to eq([url, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_url(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_url(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'invalid url' }])
    end
  end

  describe '.value_email' do
    let!(:custom_field) { create(:custom_field, :email) }
    let(:email) { 'foo@bar.com' }

    it 'returns email value' do
      expect(FieldValue.value_email(custom_field, email, {})).to eq([email, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_email(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_email(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'invalid email' }])
    end
  end

  describe '.value_date' do
    let!(:custom_field) { create(:custom_field, :date) }
    let(:date) { Date.today.to_s }

    it 'returns date value' do
      expect(FieldValue.value_date(custom_field, date, {})).to eq([date, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_date(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'invalid value returns an error' do
      custom_field.required = true
      expect(FieldValue.value_date(custom_field, 'x', {})).to eq(['x', { "_#{custom_field.id}".to_sym => 'invalid date' }])
    end

    it 'nil value returns an error' do
      custom_field.required = true
      expect(FieldValue.value_date(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_datetime' do
    let!(:custom_field) { create(:custom_field, :datetime) }
    let(:datetime) { Time.current.to_s }

    it 'returns datetime value' do
      expect(FieldValue.value_datetime(custom_field, datetime, {})).to eq([datetime, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_datetime(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'invalid value returns an error' do
      custom_field.required = true
      expect(FieldValue.value_datetime(custom_field, 'x', {})).to eq(['x', { "_#{custom_field.id}".to_sym => 'invalid datetime' }])
    end

    it 'nil value returns an error' do
      custom_field.required = true
      expect(FieldValue.value_datetime(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_time' do
    let!(:custom_field) { create(:custom_field, :time) }
    let(:time) { Time.current }

    it 'returns time value' do
      expect(FieldValue.value_time(custom_field, time, {})).to eq([time, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_time(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'invalid value returns an error' do
      custom_field.required = true
      expect(FieldValue.value_time(custom_field, 'x', {})).to eq(['x', { "_#{custom_field.id}".to_sym => 'invalid time' }])
    end

    it 'nil value returns an error' do
      custom_field.required = true
      expect(FieldValue.value_time(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_checkbox' do
    let!(:custom_field) { create(:custom_field, :checkbox) }

    it 'returns checkbox 1 value' do
      expect(FieldValue.value_checkbox(custom_field, '1', {})).to eq(['1', {}])
    end

    it 'returns checkbox 0 value' do
      expect(FieldValue.value_checkbox(custom_field, '0', {})).to eq(['0', {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_checkbox(custom_field, nil, {})).to eq([nil, {}])
    end
  end

  describe '.value_text' do
    let!(:custom_field) { create(:custom_field, :text) }

    it 'returns text value' do
      expect(FieldValue.value_text(custom_field, 'foo', {})).to eq(['foo', {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_text(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_text(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_number' do
    let!(:custom_field) { create(:custom_field, :number) }

    it 'returns number value' do
      expect(FieldValue.value_number(custom_field, 123, {})).to eq([123, {}])
    end

    it 'returns zero for nil' do
      expect(FieldValue.value_number(custom_field, nil, {})).to eq([0, {}])
    end

  end

  describe '.value_textarea' do
    let!(:custom_field) { create(:custom_field, :textarea) }

    it 'returns text value' do
      expect(FieldValue.value_textarea(custom_field, 'foo', {})).to eq(['foo', {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_textarea(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_textarea(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_range' do
    let!(:custom_field) { create(:custom_field, :range) }

    it 'returns text value' do
      expect(FieldValue.value_range(custom_field, 51, {})).to eq([51, {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_range(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_range(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end

  describe '.value_color' do
    let!(:custom_field) { create(:custom_field, :color) }

    it 'returns text value' do
      expect(FieldValue.value_color(custom_field, '#0000000', {})).to eq(['#0000000', {}])
    end

    it 'returns nil' do
      expect(FieldValue.value_color(custom_field, nil, {})).to eq([nil, {}])
    end

    it 'returns an error' do
      custom_field.required = true
      expect(FieldValue.value_color(custom_field, nil, {})).to eq([nil, { "_#{custom_field.id}".to_sym => 'required field' }])
    end
  end
end
