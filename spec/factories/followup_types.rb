FactoryBot.define do
  factory :followup_type do
    sequence :name do |n|
      "Name #{n}"
    end
  end
end
