#!/usr/bin/env ruby

# It's always bugged me that I can't take a list of words and find the length of
# the longest word simply by saying ray.max(&:size). Ruby gives us max and
# max_by. Max lets us get the max item in a list (as found by using <=>), and
# max_by lets us get the item that has the maximum value after a transform. But
# if you do a transform, you get the item, not the value of the transform.
#
# So, I can get the longest word with words.max_by(&:size), and I can get the
# length of the longest word with words.map(&:size).max, but I can't do the
# transform and get the max in one step.
#
# There's a couple ways to do this in standard ruby:
#
# ray.map(&:size).max
# ray.max_by(:size).size
#
# Of the two I prefer the readability of the first. It's also about 16% faster
# at finding the length of the longest word in /usr/share/dict/words (about
# 236,000 words totalling 249MB on OSX Catalina in 2021). The gap narrows to
# about 10% for smaller arrays. No data on what the memory impact is between the
# two; unclear in ray.max_by(:size).size would be gentler on a machine with
# scarce memory.
#
# Were I to monkeypatch this into Ruby proper, I would probably override max/1
# to check for Symbol vs Integer, allow max/0 to take a block, and allow
# max/1(int) to take a block. The standard implementation of ray.max(n) returns
# the n largest values.
#
# | method                              | what it does                            |
# | items.max                           | returns largest item                    |
# | items.max(3)                        | returns largest 3 items                 |
# | items.max_by(&:size)                | returns item with largest item.size     |
| # items.max_by {|item| item.size }    | returns item with largest item.size     |
# | items.max_by(3, &:size)             | returns 3 items with largest item.sizes |
# | items.max_by(3) {|item| item.size } | returns 3 items with largest item.sizes |
# | items.max_of(&:size)                |
# For now, here is Array#max_of, which takes a symbol only, as I do not know how
# to receive a block and then turn it into a message send.

class Array
  # Sends message to each element, then returns the maximum value returned
  def max_of(message=nil, &block)
    if block_given?
      map(&block).max
    else
      raise ArgumentError, "Array#max_of requires a message or a block" unless message
      map(&message.to_sym).max
    end
  end
end


if __FILE__==$0
  ray = ["alice", "bob", "carol", "dave"]
  puts ray.max_of :size
  puts ray.max_of(&:size)
  puts ray.max_of "size"
end
