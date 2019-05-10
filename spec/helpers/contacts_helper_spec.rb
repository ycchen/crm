require 'rails_helper'

RSpec.describe ContactsHelper, type: :helper do

  let(:contact) { create(:contact) }

  describe '#pretty_contact' do
    it 'returns html formatted contact info' do
      expected = "<b>#{contact.first_name} #{contact.last_name}</b><br />123 Cherry Lane<br />City #{contact.state.abbr}, 12345<br />#{contact.email}"
      expect(helper.pretty_contact(contact)).to eq(expected)
    end
  end

  describe '#pretty_contact_phone' do
    let(:phone) { create(:phone) }

    it 'returns formatted phone' do
      expected = '(123) 123-1234 (Phone Type)'
      expect(helper.pretty_contact_phone(phone)).to eq(expected)
    end
  end
end
