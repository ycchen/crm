require 'rails_helper'

RSpec.describe Note, type: :model do

  describe 'validation' do
    let(:note) { create(:note) }

    it 'has a valid factory' do
      expect(note.valid?).to be_truthy
    end

    it 'requires a contact' do
      note.contact = nil
      expect(note.valid?).to be_falsey
    end

    it 'requires a note' do
      note.note = nil
      expect(note.valid?).to be_falsey
    end
  end

  describe '#pretty_created_at' do
    let(:note) { create(:note) }

    it 'returns a formatted timestamp' do
      now = Time.current
      note.created_at = now
      expect(note.pretty_created_at).to eq(now.strftime('%b %e, %Y %l:%M %p %Z'))
    end
  end
end
