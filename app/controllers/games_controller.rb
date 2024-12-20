class GamesController < ApplicationController
  def index
    @games = Game.all
    render json: @games
  end

  def create
    game = Game.new(game_params)
    if game.save
      render json: {
        id: game.id,
        name: game.name,
        max_players: game.max_players,
        current_players: []
      }, status: :created
    else
      render json: {message: game.errors.full_messages.to_sentence}, status: :internal_server_error
    end
  end

  def join
    player = Player.find_by_id(params[:player_id])
    if player.nil?
      return render json: {
        message: "Player not found"
      }, status: :not_found
    end

    game = Game.find(params[:id])
    if game.nil?
      return render json: {
        message: "Room does not exists"
      }, status: :not_found
    end

    if PlayerGame.find_by(player_id: player.id)
      return render json: { message: "Player already in game" }, status: :forbidden
    end

    player_game = PlayerGame.new(game: game, player: player, status: "active")
    if player_game.save
      render json: {
        message: "Player joined successfully"
      }, status: :created
    else
      render json: {
        message: player_game.errors.full_messages.to_sentence
      }, status: :internal_server_error
    end
  end

  def leave
    player = Player.find_by_id(params[:player_id])
    if player.nil?
      return render json: {
        message: "Player not found"
      }, status: :not_found
    end

    game = Game.find(params[:id])
    if game.nil?
      return render json: {
        message: "Room does not exists"
      }, status: :not_found
    end

    player_game = PlayerGame.find_by(game: game, player: player)
    if player_game.nil?
      return render json: {
        message: "Player is not registered in this game"
      }, status: :internal_server_error
    end

    if player_game.destroy
      player_game.save
      render json: {
        message: "Player left successfully"
      }, status: :ok
    else
      render json: {
        message: player_game.errors.full_messages.to_sentence,
      }, status: :internal_server_error
    end

  end

  def start
  #   marcar estado do jogo como iniciado
  # para cada player é preciso iniciar as cartas de cada um -> duas para cada
  # para cada player é preciso iniciar a quantidade de fichas
  # retornar um array com os players que entraram
  # gerar cartas da mesa comunity_cards
  # iniciar o pot com 0
  end


  def game_params
    params.require(:game).permit(:name, :max_players)
  end
end
