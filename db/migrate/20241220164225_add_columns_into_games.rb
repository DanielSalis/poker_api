class AddColumnsIntoGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :cards, :jsonb, default: {}
    add_column :games, :stage, :string
  end
end
