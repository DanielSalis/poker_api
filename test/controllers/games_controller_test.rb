require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:one)
  end

  test "should get index" do
    get games_url, as: :json
    assert_response :success
  end

  # test "should create game" do
  #   assert_difference("Game.count") do
  #     post games_url, params: { game: { available_cards: @game.available_cards, cards: @game.cards, comunity_cards: @game.comunity_cards, id: @game.id, is_showdown: @game.is_showdown, max_players: @game.max_players, name: @game.name, phase: @game.phase, pot: @game.pot, status: @game.status } }, as: :json
  #   end

  #   assert_response :created
  # end

  test "should show game" do
    get game_url(@game), as: :json
    assert_response :success
  end

  test "should update game" do
    patch game_url(@game), params: { game: { available_cards: @game.available_cards, cards: @game.cards, comunity_cards: @game.comunity_cards, id: @game.id, is_showdown: @game.is_showdown, max_players: @game.max_players, name: @game.name, phase: @game.phase, pot: @game.pot, status: @game.status } }, as: :json
    assert_response :success
  end

  test "should destroy game" do
    assert_difference("Game.count", -1) do
      delete game_url(@game), as: :json
    end

    assert_response :no_content
  end
end
