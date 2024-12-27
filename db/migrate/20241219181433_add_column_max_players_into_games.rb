class AddColumnMaxPlayersIntoGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :max_players, :integer
  end
end
