FactoryBot.define do

  factory :field_option do
    custom_field { CustomField.first || create(:custom_field) }
    sequence(:name) { |n| "Option #{n}" }
  end

end
