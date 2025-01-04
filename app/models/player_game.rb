class PlayerGame < ApplicationRecord
  belongs_to :game
  belongs_to :player
  # after_update_commit :broadcast_player_action
  # after_create_commit :broadcast_player_join
  # after_destroy_commit :broadcast_player_left

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
          name: "action",
          player_id: player_id,
          last_action: last_action,
          bet: bet,
          chips: chips
        },
        player_data: self,
        message: "#{player.username} did the action: #{last_action}."
      }
    )
  end

  def broadcast_player_join
    GameChannel.broadcast_to(
      game,
      {
        action: {
          name: "join",
          player_id: player_id,
          chips: chips
        },
        player_data: self,
        message: "#{player.username} has joined."
      }
    )
  end

  def broadcast_player_left
    GameChannel.broadcast_to(
      game,
      {
        action: {
          name: "delete",
          player_id: player_id,
          chips: chips
        },
        message: "#{player.username}  - #{player.id} has left."
      }
    )
  end

end
