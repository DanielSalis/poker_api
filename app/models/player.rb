class Player < ApplicationRecord
  has_many :player_games

  validates :username, presence: true
end
