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

# TODO: Hello from 2023-02-22, I just discovered plural and multi options,
# EXCEPT THEY DON'T WORK, SO TEST THIS PLEASE?
#
# - mulitple values: Just pluralize the type, or set the default to [TypeClass].
# - multiple occurrences of an arg: set multi: true
#
# How it should work:
#   opt :sizes, type: :ints
#   opt :names, default: [String]
#   opt :file, type: :string, multi: true
#   opt :batches, type: :strings, multi: true
#
# How you would call them:
#   --sizes 8 9 9
#   --names Alice Bob Carol
#   --file=1.txt --file=2.txt
#   --batches a b c --batches d e
#
# How you should receive them:
#   opts[:sizes] == [8, 9, 9]
#   opts[:names] == ["Alice", "Bob", "Carol"]
#   opts[:file] == ["1.txt", "2.txt"]
#   opts[:batches] == [["a", "b", "c"], ["d", "e"]]
#
# Right now when I try these I get e.g. sizes_given=true, sizes=true, which
# makes it look like a flag? Maybe it's incomplete? Idk.

require 'optimist'

p = Optimist::Parser.new do
  banner "optimist_example2.rb [options] <targetfile>"

  # don't raise `Error: unknown argument '<arg>'`
  @ignore_invalid_options = true # no error given if you call this with --xyzzyx

  opt :monkey, "Use monkey mode"            # a flag --monkey, defaulting to false
  opt :goat, "Use goat mode", default: true # a flag --goat, defaulting to true
end

opts = Optimist::with_standard_exception_handling p do
  o = p.parse ARGV
  raise Optimist::HelpNeeded if ARGV.empty? # show help screen
  o
end

puts "Options:"
puts opts.inspect
puts "--"
puts "Leftover Args:"
puts ARGV
puts "--"
puts "Sizes:"
puts opts[:sizes].inspect
