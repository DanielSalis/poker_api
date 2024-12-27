class AddGamePhaseColumn < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :phase, :integer, default: 0
  end
end
