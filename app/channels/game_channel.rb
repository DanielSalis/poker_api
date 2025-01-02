class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find(params[:game_id])
    stream_for game
  end

  def unsubscribed
    # current_player = Player.find(params[:player_id])
    # ActionCable.server.broadcast(
    #   "game_#{params[:game_id]}",
    #   { action: "player_disconnected", player_id: current_player.id }
    # )
  end
end
