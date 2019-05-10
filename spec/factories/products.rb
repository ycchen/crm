FactoryBot.define do
  factory :product do
    user { User.first || create(:user) }
    name { Faker::Food.ingredient }
    desc { Faker::Lorem.paragraph(3) }
    price { Faker::Number.between(5, 49) + 0.95 }
    img { File.new("#{Rails.root}/spec/factories/images/product.png") }
  end
end
