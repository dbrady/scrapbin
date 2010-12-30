#!/usr/bin/env ruby

# Stupid little hack for Fallout 3 to help defeat the "Access
# Computer" terminal minigame. To Use:
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
# 7 different number matches. If the game says 2 letters match, then
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
# 
# Output:
# 
#        : lurking serving implies fertile meeting warlike warring melting burning worried farming decries gunfire mirrors further warning mention finding landing
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
# lurking:       7       4       1       2       3       2       4       3       5       2       4       1       2       1       2       4       1       3       4 
# serving:       4       7       1       3       4       2       4       4       4       2       4       2       1       1       1       4       2       3       3 
# implies:       1       1       7       1       1       2       1       1       1       2       1       3       1       1       1       1       1       1       1 
# fertile:       2       3       1       7       3       3       2       3       2       2       3       2       2       1       3       2       3       2       1 
# meeting:       3       4       1       3       7       1       3       6       3       1       3       2       1       1       1       3       4       3       3 
# warlike:       2       2       2       3       1       7       4       1       2       3       3       1       2       1       1       4       1       1       2 
# warring:       4       4       1       2       3       4       7       3       4       4       5       2       1       2       1       6       1       3       4 
# melting:       3       4       1       3       6       1       3       7       3       1       3       2       1       1       1       3       4       3       3 
# burning:       5       4       1       2       3       2       4       3       7       2       4       1       2       1       2       5       1       3       3 
# worried:       2       2       2       2       1       3       4       1       2       7       2       3       1       2       2       3       1       1       1 
# farming:       4       4       1       3       3       3       5       3       4       2       7       1       1       1       2       5       1       4       4 
# decries:       1       2       3       2       2       1       2       2       1       3       1       7       1       2       1       1       2       1       1 
# gunfire:       2       1       1       2       1       2       1       1       2       1       1       1       7       1       1       1       2       2       2 
# mirrors:       1       1       1       1       1       1       2       1       1       2       1       2       1       7       1       1       1       1       0 
# further:       2       1       1       3       1       1       1       1       2       2       2       1       1       1       7       1       1       1       0 
# warning:       4       4       1       2       3       4       6       3       5       3       5       1       1       1       1       7       1       3       4 
# mention:       1       2       1       3       4       1       1       4       1       1       1       2       2       1       1       1       7       2       2 
# finding:       3       3       1       2       3       1       3       3       3       1       4       1       2       1       1       3       2       7       5 
# landing:       4       3       1       1       3       2       4       3       3       1       4       1       2       0       0       4       2       5       7 
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------
#        :       6       5       4       4       6       5       7       6       6       5       6       4       3       4       5       7       5       6       7 

# 
# ----------------------------------------------------------------------
# TODO: Add knowns.
# 
# By this I mean make the game more interactive, and give the ability
# to say "Okay, I tried 'landing', and it said "3/7 letters match." So
# the user could type "landing 3", and the game would filter out all
# words except for serving, meeting, melting, and burning, then
# redisplay the new grid, e.g.:
# 
#        : serving meeting melting burning
# ----------------------------------------
# serving:       7       4       4       4 
# meeting:       4       7       6       3 
# melting:       4       6       7       3 
# burning:       4       3       3       7 
# ----------------------------------------
#        :       2       4       4       3 
# Knowns:
#    landing 3
# 
# From this second grid we can see that guessing meeting or melting
# will lead us to the correct answer in guess 3.
# ----------------------------------------------------------------------

# words = %w(
# slips
# raise
# waves
# waits
# thief
# raids
# wrist
# wakes
# trips
# weird
# write
# ruins
# nails
# cried
# races
# wares
# )
words = %w(
serving
meeting
melting
burning
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
