class StatisticsController < ApplicationController
  before_action { @section = 'statistics' }

  # GET /statistics
  # GET /statistics.json
  def index
    @players = Player.all
    @player_count_total = @players.count
  end

end
