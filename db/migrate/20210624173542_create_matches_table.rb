class CreateMatchesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table(:matches, force: true)
    create_table :matches do |t|
      t.integer :player_id_1
      t.integer :player_id_2
      t.integer :player1_set_1
      t.integer :player1_set_2
      t.integer :player1_set_3
      t.integer :player2_set_1
      t.integer :player2_set_2
      t.integer :player2_set_3
      t.datetime :start_time
      t.integer :winner_id

      t.timestamps
    end
  end
end
