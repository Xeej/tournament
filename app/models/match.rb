class Match < ApplicationRecord
  validates :player_id_1, presence: true
  validates :player_id_2, presence: true

  validates :player1_set_1, presence: true, if: ->{ player2_set_1.present? || player2_set_2.present? || player2_set_3.present? || player1_set_2.present? || player1_set_3.present? }
  validates :player2_set_1, presence: true, if: ->{ player1_set_1.present? || player1_set_2.present? || player1_set_3.present? || player2_set_2.present? || player2_set_3.present? }
  validates :player1_set_2, presence: true, if: ->{ player2_set_2.present? || player2_set_3.present? || player1_set_3.present? }
  validates :player2_set_2, presence: true, if: ->{ player1_set_2.present? || player1_set_3.present? || player2_set_3.present? }
  validates :player1_set_3, presence: true, if: ->{ player2_set_3.present? }
  validates :player2_set_3, presence: true, if: ->{ player1_set_3.present? }

  validates :start_time, presence: true
  before_validation :default_start_time, on: [:create, :update]

  validate :check_player1, on: [:create, :update]
  validate :check_player2, on: [:create, :update]
  validate :players_eql, on: [:create, :update]
  before_update :winner_update
  before_create :winner_create
  after_destroy :destroy_players_score

  def destroy_players_score
    return if winner_id.nil?

    current_loser, current_winner = player1.id.eql?(self.winner_id) ? [player2, player1] : [player1, player2]
    current_loser.update(losses: current_loser.losses - 1)
    current_winner.update(wins: current_winner.wins - 1)
  end

  def winner_create
    player_winner = calc_winner
    self.winner_id = player_winner&.id
    return if player_winner.nil?

    player_winner.update(wins: player_winner.wins + 1)
    current_loser = player_winner.eql?(player1) ? player2 : player1
    current_loser.update(losses: current_loser.losses + 1)
  end

  def winner_update
    player_winner = calc_winner
    self.winner_id = player_winner&.id

    old_match = Match.find(id)
    old_winner = Player.find_by(id: old_match.winner_id)

    old_winner&.update(wins: old_winner.wins - 1)
    player_winner&.reload&.update(wins: player_winner.wins + 1)
    
    old_loser = old_match.player1.id.eql?(old_match.winner_id) ? old_match.player2 : old_match.player1
    old_loser&.update(losses: old_loser.losses - 1)

    current_loser = player1.id.eql?(self.winner_id) ? player2 : player1
    current_loser&.reload&.update(losses: old_loser.losses + 1)
  end

  def calc_winner
    return nil unless player1_set_2.present? && player2_set_2.present? || player1_set_3.present? && player2_set_3.present?
    
    # TODO rafactoring
    scores = [0, 0]
    if player1_set_1 > player2_set_1
      scores[0] += 1
    elsif player1_set_1 < player2_set_1
      scores[1] += 1
    end

    if player1_set_2 > player2_set_2
      scores[0] += 1
    elsif player1_set_2 < player2_set_2
      scores[1] += 1
    end

    if player1_set_3.present? && player2_set_3.present?
      if player1_set_3 > player2_set_3
        scores[0] += 1
      elsif player1_set_3 < player2_set_3
        scores[1] += 1
      end
    end

    if scores[0] > scores[1]
      player1
    elsif scores[0] < scores[1]
      player2
    else
      nil
    end
  end

  def players_eql
    errors.add "#{player1.surname} #{player1.name}", 'не может играть сам с собой' if player_id_1.eql?(player_id_2)
  end

  def check_player1
    errors.add :player_id_1, 'Игрока1 не существует' unless Player.exists?(id: player_id_1)
  end

  def check_player2
    errors.add :player_id_2, 'Игрока2 не существует' unless Player.exists?(id: player_id_2)
  end

  def default_start_time
    self.start_time ||= Time.now
  end

  def player1
    Player.find(self.player_id_1)
  end

  def player2
    Player.find(self.player_id_2)
  end

  def player_winner
    Player.find(self.winner_id)
  end

end
