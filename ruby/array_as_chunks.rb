#!/usr/bin/env ruby

# Given an ordered array of integers with gaps, reduce the array to shorthand
# notation. I spent the better part of two days writing this in PHP for a client
# back in 2007. I called the chunked notation "rangelets". Now thanks to
# chunk_while, this tool less than 5 minutes. NICE!
#
# Examples:
# [1,2,3,4,5,6].as_chunks => "1..6"
# [1,2,3,6,7,8].as_chunks => "1..3,6..8"
# [1,2,5,7,8,9].as_chunks => "1..2,5,7..9"
class Array
  # I spent the better part of two days writing this in PHP for a client back in
  # 2007. Now thanks to chunk_while, it took me less than 5 minutes. NOICE.
  def as_chunks(chunk_separator=',', chunklet_separator='..')
    chunked_array = self.chunk_while {|i,j| i+1 == j }
    chunks = chunked_array.map do |chunk|
      if chunk.first == chunk.last
        chunk.first.to_s
      else
        [chunk.first, chunk.last].join chunklet_separator
      end
    end
    chunks.join chunk_separator
  end
end


if __FILE__==$0
  ray = [1,2,3,5,7,8,9,10]

  puts ray.inspect

  puts "Chunking up with default separators ('..' and ',')"
  chunks1 = ray.as_chunks
  puts chunks1.inspect
  # => "1..3,5,7..10"

  puts "Chunking up with explicit separators ('-' and '; ')"
  chunks2 = ray.as_chunks '; ', '-'
  puts chunks2.inspect
  # => "1-3; 5; 7-10"
end
