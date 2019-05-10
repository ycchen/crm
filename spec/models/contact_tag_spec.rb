require 'rails_helper'

RSpec.describe ContactTag, type: :model do

  describe 'validation' do
    let(:contact_tag) { build(:contact_tag) }

    it 'has a valid factory' do
      expect(contact_tag.valid?).to be_truthy
    end

    it 'requires a contact' do
      contact_tag.contact = nil
      expect(contact_tag.valid?).to be_falsey
    end

    it 'requires a tag' do
      contact_tag.tag = nil
      expect(contact_tag.valid?).to be_falsey
    end

    it 'requires a unique contact and tag' do
      contact_tag.save!
      contact_tag2 = build(:contact_tag, contact: contact_tag.contact, tag: contact_tag.tag)
      expect(contact_tag2.valid?).to be_falsey
    end
  end

  describe 'belongs to a contact' do
    let(:contact) { create(:contact) }
    let(:contact_tag) { create(:contact_tag, contact: contact) }

    it 'returns a contact' do
      expect(contact_tag.contact).to eq(contact)
    end
  end

  describe 'belongs to a tag' do
    let(:tag) { create(:tag) }
    let(:contact_tag) { create(:contact_tag, tag: tag) }

    it 'returns a tag' do
      expect(contact_tag.tag).to eq(tag)
    end
  end
end
