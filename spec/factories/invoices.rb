FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    association :customer
    association :merchant
  end
end
