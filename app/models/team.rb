class Team < ApplicationRecord
  has_and_belongs_to_many :matches
  has_many :players

  validates :name, presence: true, uniqueness: true

  def get_top5(achievement)
    PlayersAchievement.where(achievement: achievement, player: self.players)
      .group(:player).count.sort_by(&:last).reverse.map(&:first).first(5)
  end

  def self.get_top5(achievement)
    PlayersAchievement.where(achievement: achievement)
      .group(:player).count.sort_by(&:last).reverse.map(&:first).first(5)
  end
end
