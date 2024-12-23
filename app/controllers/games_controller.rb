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
      render json: { message: game.errors.full_messages.to_sentence }, status: :internal_server_error
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
        message: player_game.errors.full_messages.to_sentence
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
    game.pot = Integer(0)

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

  def action
    game = Game.find(params[:id])
    if game.nil?
      return render json: { message: "Game not found" }, status: :internal_server_error
    end

    player_game = PlayerGame.where(game: game, player_id: params[:player_id]).first
    if player_game.nil?
      return render json: { message: "Player not found in this game" }, status: :internal_server_error
    elsif player_game.status != "active"
      render json: { message: "Player not active to play" }, status: :forbidden
    end

    action_type = params[:action].to_s
    amount = Integer(params[:amount].to_s)

    case action_type
    when "check"
      player_game.bet = amount
      game.pot = game.pot + amount
    when "raise"
      player_game.bet = player_game.bet + amount
      game.pot = game.pot + amount
    when "fold"
      player_game.status = "folded"
    when "showdown"
      game.is_showdown = true
    else
      return render json: { message: "Invalid action" }, status: :internal_server_error
    end

    player_game.last_action = action
  end

  def next_phase
    game = Game.find(params[:id])
    if game.nil?
      return render json: { message: "Game not found" }, status: :internal_server_error
    end

    if game.status != "ongoing"
      return render json: { message: "Game must be ongoing to change phase" }, status: :internal_server_error
    end

    player_games = PlayerGame.where(game_id: game.id).where.not(status: "eliminated")
    current_phase = game.phase
    current_community_cards = game.comunity_cards

    case current_phase
    when 1
      game.distribute_community_carts
      game.is_showdown = false
    when 2
      game.withdraw_community_card
    when 3
      game.withdraw_community_card
    else
      # enters here when phase is 0
      player_games.each do |pg|
        pg.hand = game.distribute_cards_to_player
      end
    end

    game.next_phase

    render json: {
      phase: current_phase,
      community_cards: current_community_cards
    }, status: :ok
  end

  def end
    game = Game.find(params[:id])
    if game.nil?
      return render json: { message: "Game not found" }, status: :internal_server_error
    end

    players = PlayerGame.where(game_id: game.id).where.not(status: "eliminated")

    if players.size < 2
      return render json: { message: "Game is over! Winner is:" + players.first.player.username }, status: :ok
    end

    players.each do |player|
      player.status = "active"
    end

    hands = players.map { |player| PokerHand.new(player.hand) }

    most_valuable_hand = hands.max

    winners = players.select { | p |
      PokerHand.new(p.hand) == most_valuable_hand
    }

    render json: {
      winners: winners.first,
      hand: most_valuable_hand.rank
    }
  end

  def game_params
    params.require(:game).permit(:name, :max_players)
  end
end
