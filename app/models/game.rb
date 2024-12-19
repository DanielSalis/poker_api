class Game < ApplicationRecord
  enum :status, { waiting: "waiting", ongoing: "ongoing", finished: "finished" }

  validates :max_players, presence: true, inclusion: { in: 1..8 }
end
