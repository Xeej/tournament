class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :user

      t.text :text
      t.text :response

      t.timestamps
    end
  end
end
