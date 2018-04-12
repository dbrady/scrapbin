#!/usr/bin/env ruby
#
# Advanced Trollop example -- because I can never remember the Trollop
# options. This file differs from trollop_example.rb in that it uses a
# custom Trollop parser. The primary benefit of this is that you can
# raise Trollop::HelpNeeded for arbitrary reasons. Trollop::die, on
# the other hand, can only be triggered by specific arguments.
#
# So, for example, you would use this method to raise an error if the
# user did not supply extra, unnamed arguments to the script.

p = Trollop::Parser.new do
  banner "trollop_example2.rb [options] <targetfile>"
  opt :monkey, "Use monkey mode"                     # a flag --monkey, defaulting to false
  opt :goat, "Use goat mode", default: true       # a flag --goat, defaulting to true
end

opts = Trollop::with_standard_exception_handling p do
  o = p.parse ARGV
  raise Trollop::HelpNeeded if ARGV.empty? # show help screen
  o
end
