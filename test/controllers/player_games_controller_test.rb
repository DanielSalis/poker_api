# require "test_helper"

# class PlayerGamesControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @player_game = player_games(:one)
#   end

#   test "should get index" do
#     get player_games_url, as: :json
#     assert_response :success
#   end

#   test "should create player_game" do
#     assert_difference("PlayerGame.count") do
#       post player_games_url, params: { player_game: { bet: @player_game.bet, chips: @player_game.chips, game_id: @player_game.game_id, hand: @player_game.hand, last_action: @player_game.last_action, last_position: @player_game.last_position, player_id: @player_game.player_id, status: @player_game.status } }, as: :json
#     end

#     assert_response :created
#   end

#   test "should show player_game" do
#     get player_game_url(@player_game), as: :json
#     assert_response :success
#   end

#   test "should update player_game" do
#     patch player_game_url(@player_game), params: { player_game: { bet: @player_game.bet, chips: @player_game.chips, game_id: @player_game.game_id, hand: @player_game.hand, last_action: @player_game.last_action, last_position: @player_game.last_position, player_id: @player_game.player_id, status: @player_game.status } }, as: :json
#     assert_response :success
#   end

#   test "should destroy player_game" do
#     assert_difference("PlayerGame.count", -1) do
#       delete player_game_url(@player_game), as: :json
#     end

#     assert_response :no_content
#   end
# end
