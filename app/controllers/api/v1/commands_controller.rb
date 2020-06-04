class Api::V1::CommandsController < ApplicationController

  # отметить, что игрок выполнил такой-то показатель в матче
  def add_achievement
    return render_error('Wrong params') if [params[:player_id], params[:match_id], params[:achievement_id]].any?(&:blank?)

    player = Player.find(params[:player_id])
    match = Match.find(params[:match_id])
    achievement = Achievement.find(params[:achievement_id])
    players_achievement = match.players_achievements.new(player: player, achievement: achievement)

    if players_achievement.save
      render json: { status: 'ok' }
    else
      render_error(players_achievement.errors.full_messages)
    end
  end

  # проверить выполнил ли игрок конкретный показатель хотя бы 1 раз за предыдущие 5 матчей команды
  def check_achievement
    return render_error('Wrong params') if [params[:player_id], params[:achievement_id]].any?(&:blank?)

    player = Player.find(params[:player_id])
    achievement = Achievement.find(params[:achievement_id])
    result = player.has_achievement?(achievement)

    render json: { status: 'ok', result: result }
  end

  # выбрать Top-5 игроков по конкретному показателю в конкретной команде и по всем командам в целом:
  # чтобы выбрать топ-5 по всем командам, НЕ передаем params[:team_id]
  def get_top5
    return render_error('Wrong params') if params[:achievement_id].blank?

    team = params[:team_id].present? ? Team.find(params[:team_id]) : Team
    achievement = Achievement.find(params[:achievement_id])
    result = team.get_top5(achievement)

    render json: { status: 'ok', result: result }
  end

  private

  def render_error(message)
    render json: { code: 0, message: message }, status: 500
  end
end
