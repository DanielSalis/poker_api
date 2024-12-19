class TableGame < ApplicationRecord
  enum :stage, {
    preFlop: "pre-flop",
    flop: "flop",
    turn: "turn",
    river: "river"
  }

  enum :last_action, {
    check: "check",
    call: "call",
    raise: "raise",
    fold: "fold",
    showdown: "showdown"
  }
end
