class Game < ApplicationRecord
  enum :status, { waiting: "waiting", ongoing: "ongoing", finished: "finished" }
end
