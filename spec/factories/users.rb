FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    fname { 'First' }
    lname { 'Last' }
    password { 'changeme' }
    password_confirmation { 'changeme' }
    confirmed_at { Time.current }

    trait :valid_user do
      fname { Faker::Name.first_name }
      lname { Faker::Name.last_name }
      email { Faker::Internet.email }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
