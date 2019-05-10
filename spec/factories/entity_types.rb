FactoryBot.define do

  factory :entity_type do
    name { 'EntityType' }

    trait :contact do
      name { 'Contact' }
    end

    trait :followup do
      name { 'Followup' }
    end

    trait :product do
      name { 'Product' }
    end

    trait :sale do
      name { 'Sale' }
    end
  end
end
