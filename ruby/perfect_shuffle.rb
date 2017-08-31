#!/usr/bin/env ruby
# coding: utf-8
# stupid script to play around with perfect shuffles

# Perfect Shuffle: a shuffle of the deck which results in a perfect interleaving
# of the top half of the deck into the bottom half. If the deck is cut into two
# equal halves and riffled together, the cards drop right-left, right-left,
# right-left, all the way through the deck. Assuming the top half of the deck is
# in the right hand, the first card riffled down must be from the right and the
# very last card riffled down must be from the left. Otherwise the top and
# bottom card of the deck will never move.

# New Deck Order: A deck of cards fresh from the box will be in new deck
# order. Ignoring the jokers and gaff cards, the deck is ordered as follows: Ace
# through King of Hearts, Ace through King of Clubs, then King through Ace of
# Diamonds, and last comes King through Ace of Spades. This puts the Ace of
# Spades as the card you see when you take the deck from the back.

# Owing to their position touching eachother in the center of the deck, the
# Kings of Clubs and Diamonds are called the "Kissing Kings".

# A single perfect shuffle of a new deck will move the kissing kings to the top
# and bottom of the deck, and put the other two kings in kissing position.

# A single perfect shuffle of a new deck will result in the top half of the deck
# being red (King of Diamonds, Ace of Hearts, Queen of Diamonds, Two of Hearts,
# etc) and the bottom half being black.

# Perfectly shuffling a deck over and over without cutting will return the deck
# to its starting order after exactly 52 shuffles. (This was the question I set
# out to answer with this script.)

require 'colorize' # because obviously

suits = { 'H' => :red, 'C' => :black, 'D' => :red, 'S' => :black }
ranks = %w( A 2 3 4 5 6 7 8 9 T J Q K ) # use T for Ten so they're all 1 digit

new_deck = ['H', 'C'].map do |suit|
  color = suits[suit]
  ranks.map do |rank|
    "#{rank}#{suit}".white.send("on_#{color}")
  end
end.flatten + ['D', 'S'].map do |suit|
  color = suits[suit]
  ranks.reverse.map do |rank|
    "#{rank}#{suit}".white.send("on_#{color}")
  end
end.flatten

deck = new_deck.dup

puts deck == new_deck

puts '-' * 80
puts "New Deck:"
puts deck * ', '


def perfect_shuffle(deck)
  deck = deck.dup
  deck[26..52].zip(deck[0...26]).flatten
end

1.upto(100) do |i|
  deck = perfect_shuffle deck

  puts '-' * 80
  puts "Shuffle: #{i}"
  puts deck.join(', ')
  break if deck == new_deck
end
