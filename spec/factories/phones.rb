FactoryBot.define do
  factory :phone do
    association :contact
    phone_type { PhoneType.first || create(:phone_type) }
    number { '1231231234' }
  end
end
