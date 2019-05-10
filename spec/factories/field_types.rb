FactoryBot.define do

  factory :field_type do
    name { 'text' }

    trait :select do
      name { 'select' }
    end

    trait :radio do
      name { 'radio' }
    end

    trait :checkboxes do
      name { 'checkboxes' }
    end

    trait :url do
      name { 'url' }
    end

    trait :email do
      name { 'email' }
    end

    trait :date do
      name { 'date' }
    end

    trait :time do
      name { 'time' }
    end

    trait :datetime do
      name { 'datetime' }
    end

    trait :text do
      name { 'text' }
    end

    trait :checkbox do
      name { 'checkbox' }
    end

    trait :number do
      name { 'number' }
    end

    trait :color do
      name { 'color' }
    end

    trait :range do
      name { 'range' }
    end

    trait :textarea do
      name { 'textarea' }
    end
  end
end
