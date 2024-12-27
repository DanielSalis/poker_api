class AddColumnsIntoPlayerGames < ActiveRecord::Migration[8.0]
  def change
    add_column :player_games, :bet, :integer
    add_column :player_games, :last_action, :string
  end
end
