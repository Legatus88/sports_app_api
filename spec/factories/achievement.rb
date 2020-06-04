FactoryBot.define do
  factory :achievement do
    sequence(:name, 1) { |n| "achievement_#{n}" }
  end
end
