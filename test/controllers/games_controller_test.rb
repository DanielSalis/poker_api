require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = Player.create(username: "test_player", balance: 1000)
    @game = Game.create(name: "Test Game", max_players: 5, pot: 0)
  end

  # GET #index##############################################################################
  test "should get index" do
    get games_url, as: :json
    assert_response :success
  end

  # POST #create#############################################################################
  test "should create game" do
    assert_difference("Game.count") do
      post games_url, params: { game: { name: "New Game", max_players: 4 } }, as: :json
    end

    assert_response :created
  end

  # POST #join ###############################################################################
  test "should join game" do
    post join_game_url(@game), params: { player_id: @player.id }, as: :json
    assert_response :success
    assert_match "Player joined successfully", @response.body
  end

  test "should not join game if player not found" do
    post join_game_url(@game), params: { player_id: "aaabbb" }, as: :json
    assert_response :not_found
    assert_match "Player not found", @response.body
  end

  # POST #start #############################################################################
  test "should start game" do
    PlayerGame.create(game: @game, player: @player, status: "active")

    post start_game_url(@game), as: :json
    assert_response :success
    assert_match "Game started", @response.body
  end

  test "should not start game if no players joined" do
    post start_game_url(@game), as: :json
    assert_response :internal_server_error
    assert_match "At least one player needs to join", @response.body
  end

  # POST #leave ################################################################################
  test "player should leave the game" do
    PlayerGame.create(game: @game, player: @player, status: "active")

    delete leave_game_url(@game), params: {player_id: @player.id}, as: :json
    assert_response :success
  end

  test "player should not leave game if player does not exists" do
    delete leave_game_url(@game), params: { player_id: "abcabc" }, as: :json
    assert_response :not_found
    assert_match "Player not found", @response.body
  end

  # POST #action ###############################################################################
  test "should perform game action" do
    PlayerGame.create(game: @game, player: @player, status: "active")

    post perform_action_game_url (@game), params: { player_id: @player.id, action_type: "check", amount: 10 }, as: :json
    assert_response :ok
  end

  # POST #next-phase ##########################################################################
  test "should proceed to next phase" do
    @game.update(status: "ongoing")
    PlayerGame.create(game: @game, player: @player, status: "active")

    post next_phase_game_url(@game), as: :json
    assert_response :success
  end

  test "should not proceed to next phase" do
    PlayerGame.create(game: @game, player: @player, status: "active")

    post next_phase_game_url(@game), as: :json
    assert_response :internal_server_error
    assert_match "Game must be ongoing to change phase", @response.body
  end

  # POST #end ##########################################################################
  test "should end game" do
    PlayerGame.create(game: @game, player: @player, status: "active")

    post end_game_url(@game), as: :json
    assert_response :success
  end

  test "should not end game if game does not exists" do
    post end_game_url(id: "abbaasc")
    assert_response :internal_server_error
  end
end
