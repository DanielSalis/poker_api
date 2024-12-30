require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:one)
  end

  # GET #index
  test "should get index" do
    get players_url, as: :json
    assert_response :success
  end


  # POST #create #####################################
  test "should create player when it does not exist" do
    assert_difference("Player.count") do
      post players_url, params: { player: { username: "new_player", balance: 1000 } }, as: :json
    end

    assert_response :created
  end

  test "should not create player if it already exists" do
    assert_no_difference("Player.count") do
      post players_url, params: { player: { username: @player.username, balance: 500 } }, as: :json
    end

    assert_response :success
    response_body = JSON.parse(@response.body)
    assert_equal "Player already exists", response_body["message"]
  end

  test "should not create player with invalid data" do
    assert_no_difference("Player.count") do
      post players_url, params: { player: { username: "", balance: -100 } }, as: :json
    end

    assert_response :internal_server_error
    response_body = JSON.parse(@response.body)
  end

  # DELETE #destroy #######################################
  test "should destroy player" do
    assert_difference("Player.count", -1) do
      delete player_url(@player), as: :json
    end

    assert_response :success
    response_body = JSON.parse(@response.body)
    assert_equal "Player deleted successfully", response_body["message"]
  end
end
