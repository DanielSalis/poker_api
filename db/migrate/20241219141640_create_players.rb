class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :username, null: false, limit: 64
      t.decimal :balance, null: false, default: 0.0, precision: 10, scale: 2
      t.timestamps
    end
  end
end
