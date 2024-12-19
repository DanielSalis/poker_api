class AddColumnCurrentBetIntoTableGames < ActiveRecord::Migration[8.0]
  def change
    add_column :table_games, :current_bet, :integer
    add_column :table_games, :last_action, :string
  end
end
