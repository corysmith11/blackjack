require 'rubygems'
require 'pry'

# Object Oriented Blackjack game

# 1) Abstraction
# 2) Encapsulation

class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    "The #{face_value} of #{find_s}"
  end

  def to_s
    pretty_output
  end
    
  def find_s
    ret_val = case suit
                when 'H' then 'Hearts'
                when 'D' then 'Diamonds'
                when 'S' then 'Spades'
                when 'C' then 'Clubs'
              end
    ret_val
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards =[]
  ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
  cards.shuffle!
  end

  def deal_one
  cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "===> #{name}'s Hand <==="
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "Total is now #{total}"
  end

  def total
    face_values = cards.map{|card| card.face_value}

    total = 0
    face_values.each do |val|
      if val == "Ace"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    face_values.select{|val| val == "Ace"}.count.times do
      break if total <=21
      total -= 10
    end

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end
  def show_flop
    show_hand
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards =[]
  end

  def show_flop
    puts "===> Dealer's Hand <=== "
    puts "First card is hidden"
    puts "Second card is #{cards[1]}"
  end
end

class Blackjack
  attr_accessor :player, :dealer, :deck

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @player = Player.new("Player1")
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def set_player_name
    puts "What is your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_hand
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry #{player.name}, dealer hit blackjack. You lose this time"
      else
        puts "Congrats! You hit blackjack!! #{player.name} wins!!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congrats! The dealer busted. #{player.name} you win!"
      else
        puts "Sorry #{player.name}, you busted. Dealer wins.."
      end
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn"

    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "Would you like to hit or stay?"
      response = gets.chomp

    if !['hit', 'stay'].include?(response)
      puts "Please say, hit or stay"
      next
    end

    if response == 'stay'
        puts "#{player.name} chose to stay"
        break
    end

    new_card = deck.deal_one
    puts "Dealing card to #{player.name}. The card is a #{new_card}"
    player.add_card(new_card)
    puts "#{player.name}'s total is now: #{player.total}"

    blackjack_or_bust?(player)
  end
  puts "#{player.name} stays at #{player.total}"
  end
  
  def dealer_turn
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer now has a total of: #{dealer.total}"

      blackjack_or_bust?(dealer)
      end
    puts "Dealer stays at #{dealer.total}"
  end

  def who_won?
    if player.total > dealer.total
      puts "Congrats! #{player.name} Wins!! Cha-Ching!!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} you lost! Better luck next time.."
    else
      "It's a push! Atleast you didnt lose.."
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1 for yes or 2 for no?"
    if gets.chomp == '1'
    puts "Starting new game..."
    puts ""
    deck = Deck.new
    player.cards = []
    dealer.cards = []
    run
  else
    puts "Goodbye! Nice, playing with you."
    exit
  end
end

  def run
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.run