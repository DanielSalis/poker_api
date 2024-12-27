class AddColumnIsShowdownIntoGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :is_showdown, :boolean, default: false
  end
end
