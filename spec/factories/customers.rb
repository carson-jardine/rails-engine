FactoryBot.define do
  factory :customer do
    first_name { Faker::Customer.first_name }
    last_name { Faker::Customer.last_name }
  end
end
