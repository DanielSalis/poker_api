require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  setup do
   @player = Player.new(username: "Daniel", balance: 1000)
  end

  test "the truth" do
    assert true
  end
end
