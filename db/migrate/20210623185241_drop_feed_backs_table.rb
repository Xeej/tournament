class DropFeedBacksTable < ActiveRecord::Migration[5.2]
  def change
    drop_table(:alternative_gamer_tags, force: true)
    drop_table(:feedbacks, force: true)
    drop_table(:results, force: true)
    drop_table(:registrations, force: true)
    remove_column :players, :gamer_tag
    remove_column :players, :canton
    remove_column :players, :prefix
    remove_column :players, :discord_username
    remove_column :players, :twitter_username
    remove_column :players, :instagram_username
    remove_column :players, :youtube_video_ids
    add_column :players, :name, :string
    add_column :players, :surname, :string
    add_column :players, :patronymic, :string
  end
end
