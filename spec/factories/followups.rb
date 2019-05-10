FactoryBot.define do
  factory :followup do
    followup_type { FollowupType.first || create(:followup_type) }
    contact { Contact.first || create(:contact) }
    user { User.first || create(:user) }
    note { 'Note goes here.' }
    add_attribute(:when) { 3.days.from_now }
  end

  trait :completed do
    completed { Time.current }
  end

  trait :inactive do
    add_attribute(:when) { 4.months.ago }
  end
end
