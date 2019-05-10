FactoryBot.define do
  factory :sale_item do
    sale { Sale.first || create(:sale) }
    product { Product.first || create(:product) }
    price { 9.99 }
    quantity { 1 }
  end
end
