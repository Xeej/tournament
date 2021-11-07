class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.belongs_to :user

      t.string :title
      t.string :teaser
      t.text :text

      t.timestamps
    end
  end
end
