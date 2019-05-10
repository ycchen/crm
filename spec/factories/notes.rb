FactoryBot.define do
  factory :note do
    user { User.first || create(:user) }
    contact { Contact.first || create(:contact) }
    note { 'This is a note' }
  end
end
