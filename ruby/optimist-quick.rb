#!/usr/bin/env ruby
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

puts "occupation: #{opts[:occupation].inspect}"
puts "cpus: #{opts[:cpus].inspect}"
puts "dynos: #{opts[:dynos].inspect}"
puts "kitten: #{opts[:kitten].inspect}"
