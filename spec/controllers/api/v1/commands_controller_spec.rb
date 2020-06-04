require 'rails_helper'

describe Api::V1::CommandsController, type: :controller do
  let(:first_team) { create :team }
  let(:second_team) { create :team }
  let(:player) { create :player, team: first_team }
  let(:match) { create :match, teams: [first_team, second_team] }
  let(:achievement) { create :achievement }
  let(:params) {
    {
      player_id: player.id,
      match_id: match.id,
      achievement_id: achievement.id
    }
  }

  def json_response
    JSON.parse(response.body)
  end

  def perform_method(method, params)
    post method.to_sym, params: params
  end

  describe '#add_achievement' do

    context 'when everything is ok' do
      it 'returns ok' do
        perform_method('add_achievement', params)
        expect(json_response['status']).to eq('ok')
      end
    end

    context 'when achievement already exist' do
      let!(:players_achievement) { create :players_achievement, player: player, match: match, achievement: achievement }
      it 'returns error' do
        perform_method('add_achievement', params)
        expect(json_response['code']).to eq(0)
        expect(json_response['message']).to eq(["Player can't get same achievement twice in one match!"])
      end
    end

    context 'when params incorrect' do
      let(:params) { }
      it 'returns error' do
        perform_method('add_achievement', params)
        expect(json_response['code']).to eq(0)
        expect(json_response['message']).to eq('Wrong params')
      end
    end
  end

  describe 'check_achievement' do
    before { 10.times { create :match, teams: [first_team] } }

    context 'when achievement exists' do
      let(:match) { Match.last }
      let!(:players_achievement) { create :players_achievement, player: player, match: match, achievement: achievement }

      it 'returns true' do
        perform_method('check_achievement', params)
        expect(json_response['status']).to eq('ok')
        expect(json_response['result']).to eq(true)
      end
    end

    context 'when achievement doesn\'t exist' do
      let(:match) { Match.first }
      let!(:players_achievement) { create :players_achievement, player: player, match: match, achievement: achievement }

      it 'returns false' do
        perform_method('check_achievement', params)
        expect(json_response['status']).to eq('ok')
        expect(json_response['result']).to eq(false)
      end
    end

    context 'when params incorrect' do
      let(:params) { }
      it 'returns error' do
        perform_method('check_achievement', params)
        expect(json_response['code']).to eq(0)
        expect(json_response['message']).to eq('Wrong params')
      end
    end
  end

  describe 'get_top5' do
    def create_players_achievements(range, player)
      range.each do |num|
        create :players_achievement, player: player, match: Match.find(num), achievement: achievement
      end
    end

    before do
      9.times { create :player, team: first_team }
      10.times { create :player, team: second_team }
      10.times { create :match, teams: [first_team, second_team] }

      create_players_achievements((1..6), Player.find(4))
      create_players_achievements((1..5), Player.find(2))
      create_players_achievements((1..4), Player.find(3))
      create_players_achievements((1..3), Player.find(1))
      create_players_achievements([1, 2], Player.find(5))
      create_players_achievements([1], Player.find(11))
      create_players_achievements((1..7), Player.find(12))
      create_players_achievements([1, 2], Player.find(13))
    end

    context 'when team is specified' do
      let(:params) {
        {
          team_id: first_team.id, achievement_id: achievement.id
        }
      }

      before(:each) do
        perform_method('get_top5', params)
      end

      it 'returns top5 players from one team' do
        is_from_one_team = json_response['result'].map { |team| team['team_id'] }.exclude?(2)
        expect(is_from_one_team).to eq(true)
      end

      it "returns ok" do
        expect(json_response['status']).to eq('ok')
      end

      it "returns top 5" do
        expect(json_response['result'].count).to eq(5)
      end

      it "returns the best player" do
        expect(json_response['result'].first['id']).to eq(4)
      end

      it "returns 5th player" do
        expect(json_response['result'].last['id']).to eq(5)
      end
    end

    context 'when team is not specified' do
      let(:params) { { achievement_id: achievement.id } }

      before(:each) do
        perform_method('get_top5', params)
      end

      it "returns ok" do
        expect(json_response['status']).to eq('ok')
      end

      it "returns top 5" do
        expect(json_response['result'].count).to eq(5)
      end

      it "returns the best player" do
        expect(json_response['result'].first['id']).to eq(12)
      end

      it "returns 5th player" do
        expect(json_response['result'].last['id']).to eq(1)
      end

      it 'returns top5 players from both teams' do
        is_from_both_teams = json_response['result'].map { |team| team['team_id'] }.include?(2)
        expect(is_from_both_teams).to eq(true)
      end
    end

    context 'when params incorrect' do
      let(:params) { }
      it 'returns error' do
        perform_method('check_achievement', params)
        expect(json_response['code']).to eq(0)
        expect(json_response['message']).to eq('Wrong params')
      end
    end
  end
end
