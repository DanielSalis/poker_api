class Game < ApplicationRecord
  has_many :player_games
  before_create :initialize_cards

  after_update_commit :broadcast_game_state

  enum :status, {
    waiting: "waiting",
    ongoing: "ongoing",
    finished: "finished"
  }
  enum :phase, {
    preFlop:  0,
    flop: 1,
    turn: 2,
    river: 3
  }

  validates :max_players, presence: true, inclusion: { in: 1..8 }
  validates :name, presence: true

  def initialize_cards
    self.cards = Deck.full_deck.map(&:to_s).shuffle
    self.comunity_cards = []
  end

  def distribute_community_carts
    cards_array = cards.is_a?(Array) ? cards : JSON.parse(cards || "[]")
    community_cards = cards_array.pop(3)
    update!(cards: cards_array)

    community_cards
  end

  def withdraw_community_card
    cards_array = cards.is_a?(Array) ? cards : JSON.parse(cards || "[]")
    community_cards = cards_array.pop(1)
    update!(cards: cards_array)

    community_cards
  end

  def distribute_cards_to_player
    cards_array = cards.is_a?(Array) ? cards : JSON.parse(cards || "[]")
    player_card = cards_array.pop(2)
    update!(cards: cards_array)
    player_card
  end

  def next_phase
    if phase == "river"
      update!(phase: "preFlop")
    else
      update!(phase: itself.class.phases.keys[itself.class.phases[phase]+1])
    end
  end

  private

  def broadcast_game_state
    players = PlayerGame.where(game: self.id)
    GameChannel.broadcast_to(
      self,
      {
        id: id,
        status: status,
        phase: phase,
        pot: pot,
        community_cards: comunity_cards,
        players: players.map { |p| { id: p.id, username: p.username, balance: p.balance } }
      }
    )
  end
end
