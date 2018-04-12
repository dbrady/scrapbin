#!/usr/bin/env ruby

# minimal example of optparse

# For more information, see docco at
# * https://docs.ruby-lang.org/en/2.1.0/OptionParser.html
# * https://ruby-doc.org/stdlib-2.5.0/libdoc/optparse/rdoc/OptionParser.html
require 'optparse'

options = {} # define defaults here

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

puts "-" * 80
puts "options:"
p options
puts "-" * 80
puts "ARGV:"
p ARGV
puts "-" * 80
