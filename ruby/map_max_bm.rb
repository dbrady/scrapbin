#!/usr/bin/env ruby

# See array_max_of.rb. I finally got curious enough to benchmark it.

# tl;dr:
# words.max_by(:size).size  4.240336   0.030603   4.270939 (  4.285819)
# words.map(&:size).max  3.581734   0.126030   3.707764 (  3.721556)

require 'benchmark'

words = IO.readlines("/usr/share/dict/words").map(&:strip) # about 235,000 entries on OSX

words = words[0..100]

n = 500_000

Benchmark.bm do |x|
  x.report("words.max_by(:size).size") { n.times { words.max_by(&:size).size } }
  x.report("words.map(&:size).max") { n.times { words.map(&:size).max } }
end
