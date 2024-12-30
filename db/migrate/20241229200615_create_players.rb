class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :username, null: false, limit: 64
      t.integer :balance, null: false, default: 0
      t.timestamps
    end
  end
end
