#!/usr/bin/env ruby
# randweightgraph.rb - print a NxM graph with random weights
#
# randweightgraph.rb <width> <height>
#
# Example:
# $ randweightgraph.rb 5 3
# o--61--o--24--o--81--o--70--o
# |      |      |      |      |
# 96     84     84     97     33
# |      |      |      |      |
# o--31--o--62--o--11--o--97--o
# |      |      |      |      |
# 11     73     69     30     42
# |      |      |      |      |
# o--67--o--31--o--98--o--58--o
# |      |      |      |      |
# 69     89     24     71     71
# |      |      |      |      |
# o--71--o--60--o--64--o--73--o

width = (ARGV[0] || 10).to_i
height = (ARGV[1] || 10).to_i


srand 42

node_line = (['o'] * width).join('--%2d--')
bar_line = (['|'] * width).join('      ')
number_bar_line = (['%2d     '] * width) * ''

puts node_line % (0..width).to_a.map { 10+rand(90) }
height.times do
  puts bar_line
  puts number_bar_line % (0..width).to_a.map { 10+rand(90) }
  puts bar_line
puts node_line % (0..width).to_a.map { 10+rand(90) }
end

