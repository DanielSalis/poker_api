class CreateTableGames < ActiveRecord::Migration[8.0]
  def change
    create_table :table_games do |t|
      t.references :game, null: false, foreign_key: true, type: :uuid
      t.jsonb :cards
      t.references :user_current_playing, null: false, foreign_key: { to_table: :players }, type: :uuid
      t.integer :round_pot, precision: 10, scale: 2, default: 0
      t.string :stage, null: false
      t.timestamps
    end
  end
end
