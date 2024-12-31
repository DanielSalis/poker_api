class PlayerGame < ApplicationRecord
  belongs_to :game
  belongs_to :player
  after_update_commit :broadcast_player_action

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

  private

  def broadcast_player_action
    GameChannel.broadcast_to(
      game,
      {
        action: {
          player_id: player_id,
          last_action: last_action,
          bet: bet,
          chips: chips
        },
        message: "#{player.username} realizou a ação #{last_action}."
      }
    )
  end

end
