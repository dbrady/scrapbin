#!/usr/bin/env ruby
# 
# Trollop example -- because I can never remember the Trollop options.
#
# $ ruby ~/ruby/scrapbin/scraps/trollop_example.rb pants foo bar baz --cpus=3 -o rocker
# Trollop Options:
#       occupation: rocker
# occupation_given: true
#             cpus: 3
#             help: false
#       cpus_given: true
#           kitten: false
# --------------------
# Target: pants
# --------------------
# Remaining Cmdline Args:
#     0: foo
#     1: bar
#     2: baz

require 'trollop'

# Parse options
opts = Trollop.options do
  version "#{File.basename(__FILE__)} 1.0.0 (C) 2010 David Brady"
  banner <<-EOS
This script is a Trollop examplar, because I can never remember which options and crap I can include. More examples at http://trollop.rubyforge.org/

Usage:
       #{File.basename(__FILE__)} [options] <target> [<extra_args>]
where [options] are:
EOS
  
  opt :occupation, "Occupation", :type => :string, :default => 'haberdasher'
  opt :cpus, "CPUs", :type => :integer, :default => 0
  opt :dynos, "Dynowidget Factor", :type => :float, :default => 1.0
  opt :kitten, "Kitten?", :type => :boolean, :default => false
end
Trollop::die :dynos, "must be a non-negative number" unless opts[:dynos] >= 0.0
Trollop::die "Must supply target file" unless ARGV.length > 0

puts "Trollop Options:"
longest_key = opts.keys.map{|k| k.to_s.length}.max
format = "%#{longest_key}s: %s"
opts.each_pair do |key, val|
  puts(format % [key, val])
end

puts '-' * 20
target = ARGV.shift
puts "Target: #{target}"

puts '-' * 20
puts "Remaining Cmdline Args:"
ARGV.each_with_index do |arg, idx|
  puts "   %2d: %s" % [idx, arg]
end
