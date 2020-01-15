#!/usr/bin/env ruby
#
# Advanced Optimist example -- because I can never remember the Optimist
# options. This file differs from optimist_example.rb in that it uses a
# custom Optimist parser. The primary benefit of this is that you can
# raise Optimist::HelpNeeded for arbitrary reasons. Optimist::die, on
# the other hand, can only be triggered by specific arguments.
#
# So, for example, you would use this method to raise an error if the
# user did not supply extra, unnamed arguments to the script.

p = Optimist::Parser.new do
  banner "optimist_example2.rb [options] <targetfile>"
  opt :monkey, "Use monkey mode"                     # a flag --monkey, defaulting to false
  opt :goat, "Use goat mode", default: true       # a flag --goat, defaulting to true
end

opts = Optimist::with_standard_exception_handling p do
  o = p.parse ARGV
  raise Optimist::HelpNeeded if ARGV.empty? # show help screen
  o
end
