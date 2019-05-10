require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe '#sg' do
    it 'returns a glyphicon span tag' do
      expected = '<span class="glyphicon glyphicon-save"></span>'
      expect(helper.sg('save')).to eq(expected)
    end
  end

  describe '#formatted_phone' do
    it 'returns a formatted 7 digit phone number' do
      expected = '123-1234'
      expect(helper.formatted_phone('1231234')).to eq(expected)
    end

    it 'returns a formatted 10 digit phone number' do
      expected = '(123) 123-1234'
      expect(helper.formatted_phone('1231231234')).to eq(expected)
    end

    it 'returns a formatted 11 digit phone number' do
      expected = '+1 (123) 123-1234'
      expect(helper.formatted_phone('11231231234')).to eq(expected)
    end

    it 'returns an unformatted phone number' do
      expected = '123456789112'
      expect(helper.formatted_phone('123456789112')).to eq(expected)
    end
  end

  describe '#pretty_note' do
    it 'returns a glyphicon span tag' do
      expected = 'this is a note<br />with a second line'
      expect(helper.pretty_note("this is a note\r\nwith a second line")).to eq(expected)
    end
  end
end
