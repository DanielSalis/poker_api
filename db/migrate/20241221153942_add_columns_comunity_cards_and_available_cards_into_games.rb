class AddColumnsComunityCardsAndAvailableCardsIntoGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :comunity_cards, :jsonb, default: []
    add_column :games, :available_cards, :jsonb, default: []
    change_column :games, :cards, :jsonb, default: []
  end
end
