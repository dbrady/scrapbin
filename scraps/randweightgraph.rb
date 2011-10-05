#!/usr/bin/env ruby
# randweightgraph.rb - print a NxM graph with random weights
#
# randweightgraph.rb <width> <height> [<seed>]
#
# Example:
# $ randweightgraph.rb 5 3
#  o--40--o--86--o--67--o--56--o
#  |      |      |      |      |
# 22     21     14     74     53
#  |      |      |      |      |
#  o--60--o--11--o--77--o--88--o
#  |      |      |      |      |
# 24     89     76     29     43
#  |      |      |      |      |
#  o--37--o--28--o--47--o--18--o
args = ARGV.dup
if args[0] == '-d'
  args.shift
end
width = (args[0] || 10).to_i
height = (args[1] || 10).to_i
seed = (args[2] || 42).to_i

puts "width: #{width}" if $DEBUG
puts "height: #{height}" if $DEBUG

# count up the total number of edges in the graph, and make sure our
# random number keyspace is big enough to create unique random numbers
# for each edge.
total_horizontal_edges = (width-1)*height
total_vertical_edges = (height-1)*width
total_edges = total_horizontal_edges + total_vertical_edges

puts "total_horizontal_edges: #{total_horizontal_edges}" if $DEBUG
puts "total_vertical_edges: #{total_vertical_edges}" if $DEBUG
puts "total_edges: #{total_edges}" if $DEBUG
digits = 1 + (Math.log(total_edges) / Math.log(10)).floor
digits = 2 if digits < 2
puts "digits: #{digits}" if $DEBUG

# Now let's ensure ALL random numbers have that many digits, e.g. go
# 100-999 instead of 0-999
max = ('9' * (digits-1)).to_i
min = ('9' * (digits-2)).to_i
digits += 1 if max - min < total_edges
max = ('9' * (digits-1)).to_i
min = ('9' * (digits-2)).to_i

max = max - min
min += 1

puts "min: #{min}" if $DEBUG
puts "max: #{max}" if $DEBUG

srand seed
weights = (min..max).to_a.shuffle
fmt = '%%%dd' % (digits-1)
space = (fmt % 0).gsub(/./, ' ') + '    '
puts "fmt: #{fmt}" if $DEBUG
puts "space: '#{space}'" if $DEBUG

node_line = (['o'] * width).join("--#{fmt}--")
bar_line = (['|'] * width).join(space)
number_bar_line = (["#{fmt}     "] * width) * ''
indent = ' ' * ((digits-1)/2)
puts((digits-1)/2) if $DEBUG
puts "indent: '#{indent}'" if $DEBUG
puts "node_line: #{node_line}" if $DEBUG
puts "bar_line: #{bar_line}" if $DEBUG
puts "number_bar_line: #{number_bar_line}" if $DEBUG

puts indent + (node_line % (1...width).to_a.map { weights.pop })
(height-1).times do
  puts indent + bar_line
  puts number_bar_line % (1..width).to_a.map { weights.pop }
  puts indent + bar_line
  puts indent + (node_line % (1...width).to_a.map { weights.pop })
end

