require 'rails_helper'

RSpec.describe CustomField, type: :model do
  describe 'validation' do
    let(:custom_field) { build(:custom_field) }

    it 'has a valid factory' do
      expect(custom_field.valid?).to be_truthy
    end

    it 'requires an entity type' do
      custom_field.entity_type = nil
      expect(custom_field.valid?).to be_falsey
    end

    it 'requires a field type' do
      custom_field.field_type = nil
      expect(custom_field.valid?).to be_falsey
    end

    it 'requires a user' do
      custom_field.user = nil
      expect(custom_field.valid?).to be_falsey
    end

    it 'requires a name' do
      custom_field.name = nil
      expect(custom_field.valid?).to be_falsey
    end

    it 'name must be less than 256 chars' do
      custom_field.name = 'x' * 256
      expect(custom_field.valid?).to be_falsey
    end

    it 'name must be unique for user and entity type' do
      custom_field.save!
      custom_field2 = build(:custom_field, user: custom_field.user, entity_type: custom_field.entity_type, name: custom_field.name)
      expect(custom_field2.valid?).to be_falsey
    end
  end

  describe 'acts_as_list' do
    let(:custom_field1) { build(:custom_field) }
    let(:custom_field2) { build(:custom_field) }
    let(:custom_field3) { build(:custom_field) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'provides custom fields per user and entity' do
      user1.custom_fields << custom_field3
      user1.custom_fields << custom_field1
      user2.custom_fields << custom_field2
      expect(user1.custom_fields.ordered).to eq([custom_field3, custom_field1])
      expect(user2.custom_fields.ordered).to eq([custom_field2])
      expect(custom_field1.position).to eq(2)
      expect(custom_field2.position).to eq(1)
      expect(custom_field3.position).to eq(1)
    end
  end

  describe 'has many field options' do
    let(:option1) { create(:field_option) }
    let(:option2) { create(:field_option) }
    let!(:custom_field) { create(:custom_field, field_options: [option1, option2]) }

    it 'returns field options' do
      expect(custom_field.field_options).to eq([option1, option2])
    end

    it 'destroys dependent field options' do
      expect {
        custom_field.destroy
      }.to change { FieldOption.count }.by(-2)
    end
  end

  describe '.ordered' do
    let(:user) { create(:user) }
    let(:contact) { build(:entity_type, :contact, id: 1) }
    let(:followup) { build(:entity_type, :followup, id: 2) }
    let!(:custom_field1) { create(:custom_field, user: user, entity_type: contact) }
    let!(:custom_field2) { create(:custom_field, user: user, entity_type: followup) }
    let!(:custom_field3) { create(:custom_field, user: user, entity_type: contact) }

    it 'returns ordered custom fields' do
      expected = [custom_field1, custom_field3, custom_field2]
      expect(user.custom_fields.ordered).to eq(expected)
    end
  end

  describe '.for_entity' do
    let(:user) { create(:user) }
    let(:contact) { build(:entity_type, :contact, id: 1) }
    let(:followup) { build(:entity_type, :followup, id: 2) }
    let!(:custom_field1) { create(:custom_field, user: user, entity_type: contact) }
    let!(:custom_field2) { create(:custom_field, user: user, entity_type: followup) }

    it 'returns custom fields for an entity' do
      expect(user.custom_fields.for_entity(contact)).to eq([custom_field1])
    end
  end

  describe '.can_have_options?' do
    let(:text) { build(:custom_field, :text) }
    let(:select) { build(:custom_field, :select) }
    let(:radio) { build(:custom_field, :radio) }
    let(:checkboxes) { build(:custom_field, :checkboxes) }

    it 'returns false for text' do
      expect(text.can_have_options?).to be_falsey
    end

    it 'returns true for select' do
      expect(select.can_have_options?).to be_truthy
    end

    it 'returns true for radio' do
      expect(radio.can_have_options?).to be_truthy
    end

    it 'returns true for checkboxes' do
      expect(checkboxes.can_have_options?).to be_truthy
    end
  end
end
