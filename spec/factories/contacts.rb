FactoryBot.define do
  factory :contact do
    user { User.first || create(:user) }
    sequence :email do |n|
      "contact#{n}@example.com"
    end
    sequence :first_name do |n|
      "First#{n}"
    end
    sequence :last_name do |n|
      "Last#{n}"
    end
    address { '123 Cherry Lane' }
    address2 { nil }
    city { 'City' }
    association :state
    zip { '12345' }
    tags_string { nil }
    last_contacted { nil }

    trait :valid_contact do
      email { Faker::Internet.email }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      address { Faker::Address.street_address }
      address2 { rand(10) == 1 ? Faker::Address.secondary_address : nil }
      city { Faker::Address.city }
      state { State.find_by(abbr: Faker::Address.state_abbr) }
      zip { Faker::Address.postcode }
      tags_string { Faker::Lorem.words(rand(5)).join(',') }
    end
  end
end
