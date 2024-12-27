class AlterGameStatusColumn < ActiveRecord::Migration[8.0]
  def change
    change_column :games, :status, :string,  default: "waiting"
  end
end
