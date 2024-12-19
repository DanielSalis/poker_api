class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games, id: :uuid do |t|
      t.string :status, null: false
      t.decimal :pot, precision: 10, scale: 2
      t.timestamps
    end
  end
end
