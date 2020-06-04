FactoryBot.define do
  factory :team do
    sequence(:name, 1) { |n| "team_#{n}" }
  end
end
