FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Quotes::Shakespeare.hamlet_quote }
    unit_price { Faker::Commerce.price }
    association :merchant 
  end
end
