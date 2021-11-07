class CreateTournaments < ActiveRecord::Migration[5.2]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.datetime :date
      t.string :location
      t.text :comment
      t.float :registration_fee
      t.integer :occupied_seats
      t.integer :total_seats
      t.boolean :active

      t.timestamps
    end
  end
end
