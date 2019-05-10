module FollowupsHelper

  def complete_followup_link(followup, contact)
    if contact
      complete_contact_followup_path(contact, followup)
    else
      complete_followup_path(followup)
    end
  end

  def edit_followup_link(followup, contact)
    if contact
      edit_contact_followup_path(contact, followup)
    else
      edit_followup_path(followup)
    end
  end

  def edit_followup_form(followup, contact)
    if contact
      [contact, followup]
    else
      followup
    end
  end

  def cancel_edit_followup_link(contact)
    if contact
      contact_followups_path(contact)
    else
      followups_path
    end
  end
end
