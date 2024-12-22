class AlterGameStageColumn < ActiveRecord::Migration[8.0]
  def self.up
    rename_column :games, :stage, :phase
  end
end
