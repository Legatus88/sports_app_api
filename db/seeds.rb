[1,2].each do |num|
  Team.create(name: "team_#{num}")
end

(1..5).each do |num|
  [1,2].each do |sub_num|
    Team.find(sub_num).players.create(name: "player_#{sub_num}.#{num}")
  end
end

(1..10).each do |num|
  match = Match.new
  match.name = "match_#{num}"
  match.teams = [Team.first, Team.last]
  match.save
end

[1,2].each do |num|
  Achievement.create(name: "achievemet_#{num}")
end

pa1_1 = PlayersAchievement.new(player: Player.find(1), match: Match.find(1), achievement: Achievement.first)
pa1_2 = PlayersAchievement.new(player: Player.find(1), match: Match.find(2), achievement: Achievement.first)
pa1_3 = PlayersAchievement.new(player: Player.find(1), match: Match.find(3), achievement: Achievement.first)
pa2   = PlayersAchievement.new(player: Player.find(3), match: Match.find(3), achievement: Achievement.first)
pa3   = PlayersAchievement.new(player: Player.find(5), match: Match.find(9), achievement: Achievement.first)
pa4   = PlayersAchievement.new(player: Player.find(6), match: Match.find(8), achievement: Achievement.first)
pa5   = PlayersAchievement.new(player: Player.find(9), match: Match.find(6), achievement: Achievement.first)

[pa1_1, pa1_2, pa1_3, pa2, pa3, pa4, pa5].each(&:save)
