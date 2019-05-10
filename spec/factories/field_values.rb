FactoryBot.define do

  factory :field_value do
    custom_field { CustomField.first || create(:custom_field) }
    entity { Contact.first || create(:contact) }
    value { '1' }
  end

end
