FactoryBot.define do
  factory :phone_type do
    name { 'Phone Type' }

    trait :other do
      name { 'Other' }
    end
  end
end
