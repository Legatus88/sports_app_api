FactoryBot.define do
  factory :player do
    sequence(:name, 1) { |n| "player_#{n}" }
  end
end
