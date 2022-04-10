class AddColumnsToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :duration, :integer, comment: 'Время матча в минутах', default: 0
    add_column :matches, :efficiency_player_1, :integer, comment: 'Эффективность игрока 1', default: 0
    add_column :matches, :efficiency_player_2, :integer, comment: 'Эффективность игрока 2', default: 0
  end
end
