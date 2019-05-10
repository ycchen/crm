require 'rails_helper'

RSpec.describe Tag, type: :model do

  describe 'validation' do
    let(:tag) { build(:tag) }

    it 'has a valid factory' do
      expect(tag.valid?).to be_truthy
    end

    it 'requires a user' do
      tag.user = nil
      expect(tag.valid?).to be_falsey
    end

    it 'requires a name' do
      tag.name = nil
      expect(tag.valid?).to be_falsey
    end

    it 'requires a unique name' do
      tag.save!
      tag2 = build(:tag, name: tag.name)
      expect(tag2.valid?).to be_falsey
    end
  end

  describe 'belongs_to user' do
    let(:user) { create(:user) }
    let(:tag) { create(:tag, user: user) }

    it 'must have a user' do
      expect(tag.user).to eq(user)
    end
  end

  describe 'has many contact tags' do
    let(:contact) { create(:contact) }
    let(:tag1) { create(:tag) }
    let(:tag2) { create(:tag) }
    let!(:contact_tag1) { create(:contact_tag, contact: contact, tag: tag1) }
    let!(:contact_tag2) { create(:contact_tag, contact: contact, tag: tag2) }

    it 'returns contact_tags' do
      expect(tag1.contact_tags).to eq([contact_tag1])
      expect(tag2.contact_tags).to eq([contact_tag2])
    end

    it 'must be a unique tag' do
      contact_tag3 = build(:contact_tag, contact: contact, tag: tag1)
      expect(contact_tag3.valid?).to be_falsey
    end

    it 'destroys dependent contact_tags' do
      expect {
        tag1.destroy
      }.to change { ContactTag.count }.by(-1)
    end
  end

  describe 'has many contacts through contact_tags' do
    let(:tag) { create(:tag) }
    let(:contact1) { create(:contact) }
    let(:contact2) { create(:contact) }
    let!(:contact_tag1) { create(:contact_tag, contact: contact1, tag: tag) }
    let!(:contact_tag2) { create(:contact_tag, contact: contact2, tag: tag) }

    it 'returns contacts' do
      expect(tag.contacts).to eq([contact1, contact2])
    end
  end

  describe 'scopes' do
    let(:tag1) { create(:tag, name: 'a') }
    let!(:tag2) { create(:tag, name: 'b') }
    let(:contact) { create(:contact) }
    let!(:contact_tag) { create(:contact_tag, contact: contact, tag: tag1) }

    describe '.active' do
      it 'returns active tags' do
        expect(Tag.active).to eq([tag1])
      end
    end

    describe '.ordered' do
      it 'returns ordered tags' do
        expect(Tag.ordered).to eq([tag1, tag2])
      end
    end
  end

  describe '#cleanup_name' do
    let(:tag) { build(:tag, name: '--_a!@#$ 123-zsd @#efzjj!__---1ASd-0!') }
    let(:expected) { 'a 123-zsd efzjj-1asd-0' }

    it 'cleans up the name' do
      tag.send(:cleanup_name)
      expect(tag.name).to eq(expected)
    end

    it 'cleans up the name' do
      tag.save!
      expect(tag.name).to eq(expected)
    end
  end

  describe '#to_s' do
    let(:tag) { create(:tag) }

    it 'returns a string' do
      expect(tag.to_s).to eq(tag.name)
    end
  end

  describe '.get_or_create' do
    let!(:user) { create(:user) }
    let!(:tag) { create(:tag) }

    it 'returns an existing tag' do
      expect {
        expect(Tag.get_or_create(user, tag.name)).to eq(tag)
      }.to change { Tag.count }.by(0)
    end

    it 'returns a new tag' do
      expect {
        Tag.get_or_create(user, 'xyz')
      }.to change { Tag.count }.by(1)
    end
  end

end
