class Game < ApplicationRecord
  has_many :player_games

  enum :status, {
    waiting: "waiting",
    ongoing: "ongoing",
    finished: "finished"
  }
  enum :stage, {
    preFlop: "pre-flop",
    flop: "flop",
    turn: "turn",
    river: "river"
  }

  validates :max_players, presence: true, inclusion: { in: 1..8 }
  validates :name, presence: true
end
