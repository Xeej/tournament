class PlayerStatistic
  attr_reader :days_weeks, :month, :player, :year

  def initialize(player, month, year)
    @player = player
    @month = month
    @year = Integer(year)
    @days_weeks = []
  end

  def call
    day = Time.new(year, month, 1)
    days = (day..day.end_of_month)
    {
      count_match: matches(days).count,
      count_winner_match: matches(days).where(winner_id: player.id).count,
      count_winner_game: count_winner_game(days),
      count_game: count_game(days),
      count_set: count_set(days),
      count_winner_set: count_winner_set(days)
    }
  end

  private

  def matches(days = nil)
    player.matches.where({ start_time: days }.compact)
  end

  def count_winner_game(days)
    matches(days).map do |match|
      if match.player_id_1 === player.id
        [match.player1_set_1, match.player1_set_2, match.player1_set_3].map(&:to_i)
      else
        [match.player2_set_1, match.player2_set_2, match.player2_set_3].map(&:to_i)
      end
    end.flatten.sum
  end

  def count_game(days)
    matches(days).pluck(:player1_set_1, :player1_set_2, :player1_set_3, :player2_set_1, :player2_set_2, :player2_set_3).flatten.map(&:to_i).sum
  end

  def count_set(days)
    matches(days).map do |match|
      match.player1_set_3.present? ? 3 : 2
    end.sum
  end

  def count_winner_set(days)
    matches(days).map do |match|
      count = 0
      if match.player_id_1 == player.id
        count += 1 if match.player1_set_1.to_i > match.player2_set_1.to_i
        count += 1 if match.player1_set_2.to_i > match.player2_set_2.to_i
        count += 1 if match.player1_set_3.to_i > match.player2_set_3.to_i
      else
        count += 1 if match.player2_set_1.to_i > match.player1_set_1.to_i
        count += 1 if match.player2_set_2.to_i > match.player1_set_2.to_i
        count += 1 if match.player2_set_3.to_i > match.player1_set_3.to_i
      end
      count
    end.sum
  end
end