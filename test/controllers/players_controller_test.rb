require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = Player.create(username: "TestUser", balance: 1000)
  end

  test "should get index" do
    get players_url

    assert_response :success
  end
end
