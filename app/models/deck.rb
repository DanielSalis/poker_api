class Deck
  attr_reader :value, :suit

  SUITS = %w[H D C S] # Naipes: Hearts, Diamonds, Clubs, Spades
  VALUES = %w[2 3 4 5 6 7 8 9 T J Q K A]

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value}#{suit}"
  end

  def self.full_deck
    VALUES.product(SUITS).map { |value, suit| new(value, suit) }
  end

  def testeFunc
    render json: {
      message: "teste"
    }
  end
end
