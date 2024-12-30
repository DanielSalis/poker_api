require "test_helper"

class GameTest < ActiveSupport::TestCase
  setup do
    @game = Game.new(name: "Test Game", max_players: 5)
  end

  test "should validate presence of name" do
    @game.name = nil
    assert_not @game.valid?
    assert_includes @game.errors[:name], "can't be blank"
  end

  test "should validate max_players within range" do
    @game.max_players = 0
    assert_not @game.valid?

    @game.max_players = 9
    assert_not @game.valid?

    @game.max_players = 2
    assert @game.valid?
  end

  test "should have default status waiting" do
    @game.save!
    assert_equal "waiting", @game.status
  end

  test "should have default phase preFlop" do
    @game.save!
    assert_equal "preFlop", @game.phase
  end

  test "should initialize cards and community_cards before create" do
    @game.save!
    assert_not_nil @game.cards
    assert_empty @game.comunity_cards
  end

  test "should distribute community cards" do
    @game.cards = Deck.full_deck.map(&:to_s).shuffle
    @game.save!

    community_cards_initial_number = 3
    remanescent_amount_of_cards = 49

    community_cards = @game.distribute_community_carts
    assert_equal community_cards_initial_number, community_cards.size
    assert_equal remanescent_amount_of_cards, @game.cards.size
  end

  test "should withdraw a single community card" do
    @game.cards = Deck.full_deck.map(&:to_s).shuffle
    @game.save!

    community_card = @game.withdraw_community_card
    assert_equal 1, community_card.size
    assert_equal 51, @game.cards.size
  end

  test "should distribute cards to player" do
    @game.cards = Deck.full_deck.map(&:to_s).shuffle
    @game.save!

    player_cards = @game.distribute_cards_to_player
    assert_equal 2, player_cards.size
    assert_equal 50, @game.cards.size
  end

  test "should change phase" do
    @game.phase = "preFlop"
    @game.save!

    @game.next_phase
    assert_equal "flop", @game.phase

    @game.save!
    @game.next_phase
    assert_equal "turn", @game.phase

    @game.save!
    @game.next_phase
    assert_equal "river", @game.phase

    @game.save!
    @game.next_phase
    assert_equal "preFlop", @game.phase
  end
end