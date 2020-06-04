class Player < ApplicationRecord
  belongs_to :team
  has_many :matches, through: :team

  validates :name, presence: true, uniqueness: true

  # отметить, что игрок выполнил такой-то показатель в матче
  def add_achievement(achievement, match)
    match.players_achievements.new(player: self, achievement: achievement)
  end

  # проверить выполнил ли игрок конкретный показатель хотя бы 1 раз за предыдущие 5 матчей команды
  def has_achievement?(achievement)
    matches = self.matches.order(created_at: :desc).limit(5)
    PlayersAchievement.where(match: matches, player: self, achievement: achievement).present?
  end
end
