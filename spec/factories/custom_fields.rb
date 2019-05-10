FactoryBot.define do

  factory :custom_field do
    sequence(:name) { |n| "Custom Field #{n}" }
    field_type { FieldType.first || create(:field_type) }
    user { User.first || create(:user) }
    entity_type { EntityType.find_by(name: 'Contact') || create(:entity_type, :contact) }
    required { false }

    trait :select do
      field_type { FieldType.find_by(name: 'select') || create(:field_type, :select) }
    end

    trait :radio do
      field_type { FieldType.find_by(name: 'radio') || create(:field_type, :radio) }
    end

    trait :checkboxes do
      field_type { FieldType.find_by(name: 'checkboxes') || create(:field_type, :checkboxes) }
    end

    trait :url do
      field_type { FieldType.find_by(name: 'url') || create(:field_type, :url) }
    end

    trait :email do
      field_type { FieldType.find_by(name: 'email') || create(:field_type, :email) }
    end

    trait :date do
      field_type { FieldType.find_by(name: 'date') || create(:field_type, :date) }
    end

    trait :time do
      field_type { FieldType.find_by(name: 'time') || create(:field_type, :time) }
    end

    trait :datetime do
      field_type { FieldType.find_by(name: 'datetime') || create(:field_type, :datetime) }
    end

    trait :text do
      field_type { FieldType.find_by(name: 'text') || create(:field_type, :text) }
    end

    trait :checkbox do
      field_type { FieldType.find_by(name: 'checkbox') || create(:field_type, :checkbox) }
    end

    trait :number do
      field_type { FieldType.find_by(name: 'number') || create(:field_type, :number) }
    end

    trait :color do
      field_type { FieldType.find_by(name: 'color') || create(:field_type, :color) }
    end

    trait :range do
      field_type { FieldType.find_by(name: 'range') || create(:field_type, :range) }
    end

    trait :textarea do
      field_type { FieldType.find_by(name: 'textarea') || create(:field_type, :textarea) }
    end
  end
end
