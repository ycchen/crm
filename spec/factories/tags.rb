FactoryBot.define do
  factory :tag do
    user { User.first || create(:user) }
    sequence(:name) { |n| "Tag #{n}" }
  end
end
