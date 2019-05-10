FactoryBot.define do
  factory :state do
    sequence :name do |n|
      "Name #{n}"
    end
    sequence :abbr do |n|
      "N#{n}"
    end
  end
end
