require 'rails_helper'

RSpec.describe Contact, type: :model do

  describe 'validation' do
    let(:contact) { build(:contact) }

    it 'has a valid factory' do
      expect(contact.valid?).to be_truthy
    end

    it 'requires a user' do
      contact.user = nil
      expect(contact.valid?).to be_falsey
    end

    it 'requires a first name' do
      contact.first_name = nil
      expect(contact.valid?).to be_falsey
    end

    it 'requires a last name' do
      contact.last_name = nil
      expect(contact.valid?).to be_falsey
    end
  end

  describe 'belongs_to state' do
    let(:state) { create(:state) }
    let!(:contact) { create(:contact, state: state) }

    it 'has a state' do
      expect(contact.state).to eq(state)
    end

    it 'has no state' do
      contact.state = nil
      expect(contact.state).to be_nil
      expect(contact.valid?).to be_truthy
    end
  end

  describe 'has_many phones' do
    let(:phone1) { create(:phone) }
    let(:phone2) { create(:phone) }
    let!(:contact) { create(:contact, phones: [phone1, phone2]) }

    it 'has some phones' do
      expect(contact.phones.size).to eq(2)
      expect(contact.phones.include?(phone1)).to be_truthy
      expect(contact.phones.include?(phone2)).to be_truthy
    end

    it 'destroys dependent phones' do
      expect { contact.destroy }.to change { Phone.count }.by(-2)
    end
  end

  describe 'has_many notes' do
    let(:note1) { create(:note) }
    let(:note2) { create(:note) }
    let!(:contact) { create(:contact, notes: [note1, note2]) }

    it 'has some phones' do
      expect(contact.notes.size).to eq(2)
      expect(contact.notes.include?(note1)).to be_truthy
      expect(contact.notes.include?(note2)).to be_truthy
    end

    it 'destroys dependent notes' do
      expect { contact.destroy }.to change { Note.count }.by(-2)
    end
  end

  describe 'has_many followups' do
    let(:followup1) { build(:followup) }
    let(:followup2) { build(:followup) }
    let!(:contact) { create(:contact, followups: [followup1, followup2]) }

    it 'has some phones' do
      expect(contact.followups.size).to eq(2)
      expect(contact.followups.include?(followup1)).to be_truthy
      expect(contact.followups.include?(followup2)).to be_truthy
    end

    it 'destroys dependent followups' do
      expect { contact.destroy }.to change { Followup.count }.by(-2)
    end
  end

  describe 'has_many sales' do
    let(:sale1) { create(:sale) }
    let(:sale2) { create(:sale) }
    let!(:contact) { create(:contact, sales: [sale1, sale2]) }

    it 'has some sales' do
      expect(contact.sales.size).to eq(2)
      expect(contact.sales.include?(sale1)).to be_truthy
      expect(contact.sales.include?(sale2)).to be_truthy
    end

    it 'destroys dependent sales' do
      expect { contact.destroy }.to change { Sale.count }.by(-2)
    end
  end

  describe 'has many field values' do
    let(:custom_field1) { create(:custom_field) }
    let(:custom_field2) { create(:custom_field) }
    let(:field_value1) { create(:field_value, custom_field: custom_field1) }
    let(:field_value2) { create(:field_value, custom_field: custom_field2) }
    let!(:contact) { create(:contact, field_values: [field_value1, field_value2]) }

    it 'returns field values' do
      expect(contact.field_values.size).to eq(2)
      expect(contact.field_values.include?(field_value1)).to be_truthy
      expect(contact.field_values.include?(field_value2)).to be_truthy
    end

    it 'destroys dependent field values' do
      expect { contact.destroy }.to change { FieldValue.count }.by(-2)
    end
  end

  describe '#incomplete_followups' do
    let(:followup1) { create(:followup) }
    let(:followup2) { create(:followup) }
    let!(:contact) { create(:contact, followups: [followup1, followup2]) }

    it 'returns incomplete followups' do
      expect(contact.incomplete_followups).to eq([followup1, followup2])
      expect(contact.incomplete_followups.first.class).to eq(Followup)
    end
  end

  describe '#incomplete_followups_count' do
    let(:followup1) { create(:followup) }
    let(:followup2) { create(:followup) }
    let!(:contact) { create(:contact, followups: [followup1, followup2]) }

    it 'returns incomplete followups count' do
      expect(contact.incomplete_followups_count).to eq(2)
    end
  end

  describe '.ordered scope' do
    let(:contact1) { create(:contact, last_contacted: 2.days.ago) }
    let(:contact2) { create(:contact, last_contacted: 3.days.ago) }

    it 'returns contacts ordered by last_contacted asc' do
      expected = [contact2, contact1]
      expect(Contact.all.ordered).to eq(expected)
    end
  end

  describe '#fullname' do
    let(:contact) { build(:contact, first_name: 'a', last_name: 'b') }

    it 'returns a fullname' do
      expect(contact.fullname).to eq('a b')
    end
  end

  describe '#pretty_last_contacted' do
    let(:contact) { build(:contact, last_contacted: Time.current) }

    it 'returns a formatted timestamp' do
      expect(contact.pretty_last_contacted).to eq(contact.last_contacted.strftime('%b %e, %Y %l:%M %p %Z'))
    end
  end

  describe '#update_tags' do
    let(:contact) { create(:contact) }

    it 'updates tags' do
      contact.send(:update_tags)
      expect(contact.tags).to eq([])
    end

    it 'updates tags' do
      contact.tags_string = 'foo,bar,baz'
      contact.send(:update_tags)
      expect(contact.tags.collect(&:name)).to eq(%w(foo bar baz))
    end
  end

  describe '#get_tags_string' do
    let(:contact) { create(:contact, tags_string: 'foo,bar,baz') }

    it 'returns tags as a string' do
      expect(contact.get_tags_string).to eq('foo,bar,baz')
    end
  end

  describe '#sorted_tags' do
    let(:contact) { create(:contact, tags_string: 'foo,bar,baz') }

    it 'returns sorted tags' do
      expect(contact.sorted_tags.collect(&:name)).to eq(%w(baz bar foo))
    end
  end

end
