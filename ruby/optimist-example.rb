#!/usr/bin/env ruby
#
# Optimist example -- because I can never remember the Optimist options.
#
# $ ruby ~/ruby/scrapbin/scraps/optimist_example.rb pants foo bar baz --cpus=3 -o rocker
# Optimist Options:
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

require 'optimist'

# Parse options
opts = Optimist.options do
  version "#{File.basename(__FILE__)} 1.0.0 (C) 2010 David Brady"
  banner <<-EOS
This script is a Optimist examplar, because I can never remember which options and crap I can include. More examples at http://optimist.rubyforge.org/

Usage:
       #{File.basename(__FILE__)} [options] <target> [<extra_args>]
where [options] are:
EOS

  opt :occupation, "Occupation", type: :string, default: 'haberdasher'
  opt :cpus, "CPUs", type: :integer, default: 0
  opt :dynos, "Dynowidget Factor", type: :float, default: 1.0
  opt :kitten, "Kitten?", type: :boolean, default: false
end
Optimist::die :dynos, "must be a non-negative number" unless opts[:dynos] >= 0.0
Optimist::die "Must supply target file" unless ARGV.length > 0

puts "Optimist Options:"
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
