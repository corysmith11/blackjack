puts 'Welcome to the Blackjack table.' 
puts 'Who do I have the pleasure of dealing today?'
player = gets.chomp
puts ''
puts 'Hi ' + player + ', here is your first set of cards..'
puts ""

suits =  ['Hearts','Diamonds','Clubs','Spades']
cards =   ['2','3','4','5','6','7','8','9','10','Jack','queen','king','ace']
decks = 11
def sum_total(cards)
        valuearray = cards.map{|e| e[0]} # looks at the value of the second in array pair.
        total                  = 0
        valuearray.each do |value|
                if value == 'ace'
                        total        += 11                
                elsif value.to_i == 0 # jack, king, queen
                        total += 10
                else
                        total += value.to_i
                
                end
        end
        valuearray.select {|e| e == 'ace'}.count.times do
                total -= 10 if total > 21
        end
        total
end

#shuffle
deck = cards.product(suits)
(decks - 1).times do
  deck = deck + cards.product(suits)
end
deck.shuffle!

player_cards = []
dealer_cards = []

player_cards << deck.pop
dealer_cards << deck.pop
player_cards << deck.pop
dealer_cards << deck.pop


player_total = sum_total(player_cards)
dealer_total = sum_total(dealer_cards)


puts "You have a #{player_cards[0]} and a #{player_cards[1]}"
puts "For a total of: #{player_total}"
puts ""
puts "The Dealer has a #{dealer_cards[0]} and #{dealer_cards[1]}"
puts "For a total of #{dealer_total}"
puts ""

if dealer_total > 21
  puts 'Dealer busted ' + player + '! You WIN!!'
  exit
elsif dealer_total == 21
  puts "Sorry, dealer has Blackjack. You lose."
    exit
 end
 if player_total == 21
    puts "Boom!! You got BlackJack and have won the game! Well played."
    exit
end

while player_total < 21
    puts "Would you like to hit or stay?"
      decision = gets.chomp
  if decision == "hit"
    puts "You selected to hit.. Good luck!!"
    puts ""
      new_card = deck.pop
      player_cards << new_card
      player_total = sum_total(player_cards)
    
     puts "The card you were dealt is #{new_card}, Your new hand is now #{player_total}."
    elsif decision == "stay"
    puts 'You selected to stay ' + player + '.'
    puts ""
      break
    else decision != "hit" || decision != "stay"
    puts "You did not make a valid choice, Please say hit or stay"
      next
    end
  end
  while player_total > 21
    puts 'You busted ' + player + '! The dealer wins.'
    exit
end
while dealer_total < 17
  new_card = deck.pop
  dealer_cards << new_card
  dealer_total = sum_total(dealer_cards)
  puts "I am under 17, so I am going to Hit again. The card is a #{new_card}, Dealer total is now #{dealer_total}."
end
if dealer_total > 21
  puts 'Dealer busted ' + player + '! You WIN!!'
  exit
end

if dealer_total > player_total
  puts "Sorry, dealer wins this one."
elsif dealer_total < player_total
  puts 'Congrats, ' + player + ' you win!'
else
  puts "It's a push!"
end