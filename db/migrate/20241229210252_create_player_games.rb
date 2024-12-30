class CreatePlayerGames < ActiveRecord::Migration[8.0]
  def change
    create_table :player_games do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.references :game, null: false, foreign_key: true, type: :uuid
      t.integer :chips
      t.string :status
      t.jsonb :hand
      t.integer :last_position
      t.integer :bet
      t.string :last_action

      t.timestamps
    end
  end
end
