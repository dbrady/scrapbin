#!/usr/bin/env ruby
class Array
  # I spent the better part of two days writing this in PHP for a client back in
  # 2007. Now thanks to chunk_while, it took me less than 5 minutes. NOICE.
  def as_chunks
    chunked_array = self.chunk_while {|i,j| i+1 == j }
    chunks = chunked_array.map do |chunk|
      if chunk.first == chunk.last
        chunk.first.to_s
      else
        "#{chunk.first}..#{chunk.last}"
      end
    end
    chunks.join ', '
  end
end


if __FILE__==$0
  ray = [1,2,3,5,7,8,9,10]
  chunks = ray.as_chunks

  puts ray.inspect
  puts chunks.inspect
  # => "1..3,5,7..10"
end
