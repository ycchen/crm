require 'rails_helper'

RSpec.describe Followup, type: :model do

  describe 'validation' do
    let(:followup) { build(:followup) }

    it 'has a valid factory' do
      expect(followup.valid?).to be_truthy
    end

    it 'requires a followup type' do
      followup.followup_type = nil
      expect(followup.valid?).to be_falsey
    end

    it 'requires a note' do
      followup.note = nil
      expect(followup.valid?).to be_falsey
    end

    it 'requires a contact' do
      followup.contact = nil
      expect(followup.valid?).to be_falsey
    end

    it 'requires a user' do
      followup.user = nil
      expect(followup.valid?).to be_falsey
    end

    it 'requires a when timestamp' do
      followup.when = nil
      expect(followup.valid?).to be_falsey
    end
  end

  describe 'scopes' do
    let!(:followup1) { create(:followup, when: 1.day.ago) }
    let!(:followup2) { create(:followup, :inactive) }
    let!(:followup3) { create(:followup, :completed, when: 3.days.ago) }

    it 'returns incomplete followups' do
      expected = [followup1, followup2]
      expect(Followup.incomplete).to eq(expected)
    end

    it 'returns completed followups' do
      expected = [followup3]
      expect(Followup.completed).to eq(expected)
    end

    it 'returns ordered followups' do
      expected = [followup2, followup3, followup1]
      expect(Followup.ordered).to eq(expected)
    end

    it 'returns reverse ordered followups' do
      expected = [followup1, followup3, followup2]
      expect(Followup.ordered_rev).to eq(expected)
    end
  end

  describe 'update_last_contacted' do
    let!(:followup) { create(:followup) }

    it 'ignores contact last_contacted' do
      followup.save
      expect(followup.contact.last_contacted).to be_nil
    end

    it 'ignores contact last_contacted' do
      followup.update_attribute(:completed, Time.current)
      expect(followup.contact.last_contacted).to eq(followup.when)
    end
  end

  describe 'pretty_when' do
    let!(:followup) { create(:followup) }

    it 'returns a pretty timestamp' do
      expect(followup.pretty_when).to eq(followup.when.strftime('%b %e, %Y %l:%M %p %Z'))
    end
  end
end
