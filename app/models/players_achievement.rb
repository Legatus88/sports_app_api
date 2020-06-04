class PlayersAchievement < ApplicationRecord
  belongs_to :match
  belongs_to :achievement
  belongs_to :player

  validates :player, uniqueness: { scope: [:match, :achievement],
    message: "can\'t get same achievement twice in one match!"
  }
end
