class DropTableTableGames < ActiveRecord::Migration[8.0]
  def change
    drop_table if table_exists? :table_games
  end
end
