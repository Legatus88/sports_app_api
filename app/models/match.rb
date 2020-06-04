class Match < ApplicationRecord
  has_and_belongs_to_many :teams
  has_many :players_achievements
end
