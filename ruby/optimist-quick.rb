#!/usr/bin/env ruby
require 'optimist'

# Parse options
opts = Optimist.options do
  opt :occupation, "Occupation", type: :string, default: 'haberdasher'
  opt :cpus, "CPUs", type: :integer, default: 0
  opt :dynos, "Dynowidget Factor", type: :float, default: 1.0
  opt :kitten, "Kitten?", type: :boolean, default: false
end

puts "occupation: #{opts[:occupation].inspect}"
puts "cpus: #{opts[:cpus].inspect}"
puts "dynos: #{opts[:dynos].inspect}"
puts "kitten: #{opts[:kitten].inspect}"
