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
    game = Game.find(params[:id])
    if game.nil?
      return render json: { message: "Game not found" }
    else
      if game.status == "ongoing"
        return render json: { message: "Game already started" }, status: :internal_server_error
      end
      game.status = "ongoing"
    end

    player_games = PlayerGame.where(game_id: game.id)
    if player_games.empty?
      return render json: { message: "At least one player needs to join" }, status: :internal_server_error
    end

    game.initialize_cards
    game.pot = BigDecimal(0)

    player_games.each do |pg|
      pg.status = "active"
      pg.hand = game.distribute_cards_to_player
      pg.chips = pg.player.balance
      pg.save
    end

    render json: {
      message: "Game started",
      initial_state: {
        players: player_games.select("player_id, hand, chips"),
        community_cards: game.comunity_cards,
        pot: game.pot
      }
    }
  end

  def next_phase
    game = Game.find(params[:id])

  end

  def game_params
    params.require(:game).permit(:name, :max_players)
  end
end
