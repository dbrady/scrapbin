#!/usr/bin/env ruby

# It's always bugged my that I can't take a list of words and find the length of
# the longest word simply by saying ray.max(&:size). Two obvious workarounds
# present themselves:
#
# ray.map(&:size).max
# ray.max_by(:size).size
#
# Of the two I prefer the readability of the first but suspect the second may be
# more efficient. I don't know.
#
# Why can't we say ray.max(&:size) or ray.max(:size)? I do not know. The former
# is a syntax error, the second will return an Enumerator than will crash as
# soon as it is evaluated, as ruby is expected ray.max/1 to take an Integer.
#
# Were I to monkeypatch this into Ruby proper, I would probably override max/1
# to check for Symbol vs Integer, andr allow max/0 to take a block. ray.max(2)
# returns the two largest values; I can conceive of a situation in which
# ray.max(:bob) would return the bob largest values. (I may be wrong, there
# might well be a Symbol argument you could send to the max method that would
# intuitively change its behavior in a way I have not foreseen.)
#
# TODO: see if ruby core likes this enough to include it? idk.
#
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
