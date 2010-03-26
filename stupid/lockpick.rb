#!/usr/bin/env ruby
# Stupid little hack for Fallout 3 to help hack computers.
# To Use:
# 
# 1. Input the list of words from the computer.
# 
# 2. Run this script to get a grid showing the number of letters
# shared between each word and every other word.
# 
# 3. Start the guessing game by picking a word. When the game gives
# you the number of letters that match the target word, consult the
# chart to see which words are now valid.
# 
# TIP: For your first word, find the word with the most unique
# choices. When you get the number of letters back, this will produce
# the smallest set of second-choice words. For example, in the
# following set  of words, "warring", "warning" and "landing" all have
# 7 differnt number matches. If the game says 2 letters match, then
# the second-choice words are limited to "decries" and "mirrors", and
# you can afford to guess one and miss. In this list, "gunfire" is the
# worst possible word to choose with 3 unique matches. It matches 11
# words with 1 letter difference, 7 words with 2, and itself with 7.
# Choosing gunfire will eliminate about half the possible words, but
# words like "warring" reduce all but 2 or 3.
#
# words = %w(
# lurking
# serving
# implies
# fertile
# meeting
# warlike
# warring
# melting
# burning
# worried
# farming
# decries
# gunfire
# mirrors
# further
# warning
# mention
# finding
# landing
# )

words = %w(
lurking
serving
implies
fertile
meeting
warlike
warring
melting
burning
worried
farming
decries
gunfire
mirrors
further
warning
mention
finding
landing
)

def distance(w1, w2)
  w1.split(//).zip(w2.split(//)).partition {|a| a[0] == a[1]}[0].size
end

distances = Hash.new {|h,k| h[k] = Hash.new { |a,b| a[b] = 0 }}

words.each do |word1|
  words.each do |word2|
    distances[word1][word2] = distance(word1, word2)
  end
end

word_size = words[0].size
sfmt = "%#{word_size}s"
dfmt = "%#{word_size}d"

print "#{sfmt}: " % ' '
puts words * ' '
puts '-' * ((word_size + 1) * (words.size+1))

words.each do |word1|
  print "#{sfmt}: " % word1
  words.each do |word2|
    print "#{dfmt} " % distances[word1][word2]
  end
  puts 
end



puts '-' * ((word_size + 1) * (words.size+1))
print "#{sfmt}: " % ' '
words.each do |word|
  print "#{dfmt} " % distances[word].values.uniq.size
end
puts
