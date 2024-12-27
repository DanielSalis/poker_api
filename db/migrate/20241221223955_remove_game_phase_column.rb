class RemoveGamePhaseColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :games, :phase, :varchar
  end
end
