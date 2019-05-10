FactoryBot.define do
  factory :contact_tag do
    contact { Contact.first || create(:contact) }
    tag { Tag.first || create(:tag) }
  end
end
