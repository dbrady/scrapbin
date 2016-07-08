#!/usr/bin/env ruby
# How to capture $stdout
#
# NOTE: This is why you should always use $stdout in your programs and never
# ever STDOUT. STDOUT is a constant, which CAN be rewritten but will raise a
# warning, and $stdout is global so that people can redirect it.
#
# TL;DR this program replaces $stdout with a StringIO object so that puts and
# print statements get captured rather than going to the console.


require 'stringio'

# This is a stupid_program because it writes to the console instead of returning
# a string we can use
def stupid_program
  puts "HI I AM A STUPID PROGRAM BECAUSE I WRITE TO STDOUT LOL" # always writes to $stdout
end

# This is a smart program, because it writes to an IO. (Hint: you could call
# smart_program($stdout) to make me print to the screen!) NOTE THAT THIS METHOD
# STILL RETURNS NIL--it just WRITES to io with io.puts.
def smart_program(io)
  io.puts "Why hello there you much more intelligent thing!"
end

# Okay so let's compare...
puts "Stupid vs. Smart IO"

# first, we need an IO object...
buffer = StringIO.new
var = stupid_program
smart_program(buffer)
puts "I ran both programs and got the outputs of: "
puts "  Stupid: #{var.inspect}"
puts "  Smart: #{buffer.string.inspect}"


puts "Okay, let's destupefy the stupid program!"

# replace $stdout (the screen/console) with a custom buffer
buffer2 = StringIO.new
old_stdout = $stdout
$stdout = buffer2
# Now we are capture all puts and print statements! If you print something now,
# it will NOT go to the screen and the user will NOT see it--it will go into
# buffer2.

# You will not see any output here, because stupid_program's output will be
# captured into buffer2
stupid_program

# now put $stdout back to the console so we can see output again
$stdout = old_stdout

# Now let's take a look at what we captured!
puts "Hi, I'm back to printing to the console!"
puts "Here's what we captured into in buffer2..."
puts buffer2.string
