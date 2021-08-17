class AddIsAccountantToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_accountant, :boolean
    add_column :players, :two_set_amount, :integer
    add_column :players, :three_set_amount, :integer
  end
end
