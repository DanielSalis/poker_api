class PlayerGame < ApplicationRecord
  belongs_to :game
  belongs_to :player

  validates :game_id, :player_id, presence: true

  enum :status, {
    active: "active",
    folded: "folded",
    eliminated: "eliminated"
  }

  enum :last_action, {
    check: "check",
    call: "call",
    raise: "raise",
    fold: "fold",
    showdown: "showdown"
  }
end
