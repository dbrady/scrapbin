#!/usr/bin/env ruby1.9

# Demo/scrap program to read a file of numbers from stdin and sum
# them. Runs in about 2.9s. The standard Ruby shootout version at
# http://ikanobori.jp/weblog/2009/04/11/language-performance-on-the-sum-of-a-file/
# takes about 3.6 seconds.

# Notable optimizations:

# - Read input in 10Mb chunks, then assemble them. This is a huge
#   speedup over each_line, which ends up scanning input byte by byte.
# - Use use iterators like each_line instead of collection duplicators
#   like map.
# - Use inject on each line and then add them to the sum later. BigNum
#   math is slower than FixNum, so this does FixNum addition on each
#   line and then only one BigNum addition per line.

s=0
str=""
f=""

begin
  f=$stdin.read(10485760)
  str += f unless f.nil?
end until f.nil?

str.each_line do |line|
  s += line.split(" ").inject(0) do |a,b|
    a + b.to_i
  end
end

puts s

