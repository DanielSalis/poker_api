class TransformFloatColumnsIntoInt < ActiveRecord::Migration[8.0]
  def change
    change_column :games, :pot, :integer
    change_column :players, :balance, :integer
    change_column :player_games, :chips, :integer
  end
end
