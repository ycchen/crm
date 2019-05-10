FactoryBot.define do
  factory :sale do
    user { User.first || create(:user) }
    contact { Contact.first || create(:contact) }
  end
end
