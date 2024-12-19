class PlayerGame < ApplicationRecord
  enum :status, {
    active: "active",
    folded: "folded",
    eliminated: "eliminated"
  }
end
