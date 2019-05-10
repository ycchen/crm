module ContactsHelper

  def pretty_contact(contact)
    out = "<b>#{contact.fullname}</b>"
    out << "<br />#{contact.address}" if contact.address.present?
    out << "<br />#{contact.address2}" if contact.address2.present?
    out << "<br />#{contact.city} " if contact.city.present?
    out << '<br />' unless contact.city.present?
    out << contact.state.abbr if contact.state.present? && contact.state.abbr.present?
    out << ', ' if contact.state.present? && contact.state.abbr.present? && contact.zip.present?
    out << contact.zip if contact.zip.present?
    out << "<br />#{contact.email}" if contact.email.present?
    out << "<br />#{sg('tags')} &nbsp;#{contact.tags.join(', ')}" unless contact.tags.empty?
    out.html_safe
  end

  def pretty_contact_phone(phone)
    "#{formatted_phone(phone.number)} (#{phone.phone_type.name})"
  end

end
