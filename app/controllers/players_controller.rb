class PlayersController < ApplicationController
  def index
    players = Player.all
    render json: players
  end

  def create
    player = Player.find_by(username: player_params[:username])

    if nil != player
      return render json: { message: "Player already exists" }, status: 401
    end

    player = Player.new(player_params)
    if player.save
      render json: {
        id: player.id,
        username: player.username,
        chips: player.balance
      }, status: :created
    else
      render json: {
        errors: player.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def destroy
    player = Player.find(params[:id])
    if player.destroy
      render json: {
        "message": "Player deleted successfully"
      }, status: :ok
    else
      render json: {
        "message": player.errors.full_messages
      }, status: :internal_server_error
    end
  end

  def player_params
    params.require(:player).permit(:username, :balance)
  end
end
