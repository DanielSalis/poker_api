class TableGame < ApplicationRecord
  enum :stage, {
    preFlop: "pre-flop",
    flop: "flop",
    turn: "turn",
    river: "river"
  }
end
