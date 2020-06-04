FactoryBot.define do
  factory :match do
    sequence(:name, 1) { |n| "match_#{n}" }
  end
end
