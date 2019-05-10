require 'rails_helper'

RSpec.describe FollowupsHelper, type: :helper do

  describe '#complete_followup_link' do
    let(:contact) { create(:contact) }
    let(:followup) { create(:followup) }

    it 'returns a followup link' do
      expected = complete_followup_path(followup)
      expect(helper.complete_followup_link(followup, nil)).to eq(expected)
    end

    it 'returns a contact followup link' do
      expected = complete_contact_followup_path(contact, followup)
      expect(helper.complete_followup_link(followup, contact)).to eq(expected)
    end
  end

  describe '#edit_followup_link' do
    let(:contact) { create(:contact) }
    let(:followup) { create(:followup) }

    it 'returns a followup link' do
      expected = edit_followup_path(followup)
      expect(helper.edit_followup_link(followup, nil)).to eq(expected)
    end

    it 'returns a contact followup link' do
      expected = edit_contact_followup_path(contact, followup)
      expect(helper.edit_followup_link(followup, contact)).to eq(expected)
    end
  end

  describe '#edit_followup_form' do
    let(:contact) { create(:contact) }
    let(:followup) { create(:followup) }

    it 'returns a followup link' do
      expected = followup
      expect(helper.edit_followup_form(followup, nil)).to eq(expected)
    end

    it 'returns a contact followup link' do
      expected = [contact, followup]
      expect(helper.edit_followup_form(followup, contact)).to eq(expected)
    end
  end

  describe '#cancel_edit_followup_link' do
    let(:contact) { create(:contact) }

    it 'returns a followup link' do
      expected = followups_path
      expect(helper.cancel_edit_followup_link(nil)).to eq(expected)
    end

    it 'returns a contact followup link' do
      expected = contact_followups_path(contact)
      expect(helper.cancel_edit_followup_link(contact)).to eq(expected)
    end
  end
end
