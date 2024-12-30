class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games, id: :uuid do |t|
      t.string  :status, default: 'waiting', null: false
      t.integer :pot
      t.integer :max_players
      t.string  :name
      t.jsonb   :cards, default: []
      t.jsonb   :comunity_cards, default: []
      t.jsonb   :available_cards, default: []
      t.integer :phase, default: 0
      t.boolean :is_showdown, default: false

      t.timestamps
    end
  end
end
