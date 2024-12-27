class CreatePlayerGames < ActiveRecord::Migration[8.0]
  def change
    create_table :player_games do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.references :game, null: false, foreign_key: true, type: :uuid
      t.decimal :chips, precision: 10, scale: 2
      t.string :status, null: false
      t.jsonb :hand
      t.integer :last_position
      t.timestamps
    end
  end
end
