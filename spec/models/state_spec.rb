require 'rails_helper'

RSpec.describe State, type: :model do

  describe 'validation' do
    let(:state) { build(:state) }

    it 'has a valid factory' do
      expect(state.valid?).to be_truthy
    end

    it 'requires a name' do
      state.name = nil
      expect(state.valid?).to be_falsey
    end

    it 'requires a name less than 256 chars' do
      state.name = 'x' * 256
      expect(state.valid?).to be_falsey
    end

    it 'requires an abbreviation' do
      state.abbr = nil
      expect(state.valid?).to be_falsey
    end

    it 'requires an abbreviation less than 256 chars' do
      state.abbr = 'x' * 256
      expect(state.valid?).to be_falsey
    end

    it 'requires a unique name' do
      state.save!
      state2 = build(:state, name: state.name)
      expect(state2.valid?).to be_falsey
    end

    it 'requires a unique abbreviation' do
      state.save!
      state2 = build(:state, abbr: state.abbr)
      expect(state2.valid?).to be_falsey
    end
  end

  describe 'has many contacts' do
    let(:state) { create(:state) }
    let!(:contact1) { create(:contact, state: state) }
    let!(:contact2) { create(:contact, state: state) }

    it 'returns contacts' do
      expect(state.contacts.size).to eq(2)
      expect(state.contacts.include?(contact1)).to be_truthy
      expect(state.contacts.include?(contact2)).to be_truthy
    end

    it 'nullifies on destroy' do
      expect {
        state.destroy
      }.to change { Contact.count }.by(0)
      contact1.reload
      contact2.reload
      expect(contact1.state).to be_nil
      expect(contact2.state).to be_nil
    end
  end

end
