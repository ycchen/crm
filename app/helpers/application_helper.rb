module ApplicationHelper

  def sg(glyph)
    "<span class=\"glyphicon glyphicon-#{glyph}\"></span>".html_safe
  end

  def formatted_phone(number)
    case number.size
    when 7
      return "#{number[0..2]}-#{number[3..6]}"
    when 10
      return "(#{number[0..2]}) #{number[3..5]}-#{number[6..9]}"
    when 11
      return "+#{number[0]} (#{number[1..3]}) #{number[4..6]}-#{number[7..10]}"
    end
    number
  end

  def pretty_note(note)
    note.gsub(/\r\n/, '<br />')
  end

end
