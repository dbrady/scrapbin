#!/usr/bin/env ruby
# Silly scrap program to demonstrate how *args get handled in ruby. Also
# demonstrates using caller to get the source code where a message was sent.
#
# TL;dr: *args always wraps the given args in an array. If you pass an array, it
# treats the given array as a single object and wraps it in another array.
#
# So, given foo(*args):
#
# | Call as  | Receive args as |
# |----------|-----------------|
# | foo()    | []              |
# | foo(1)   | [1]             |
# | foo([1]) | [[1]]           |
#
# Implication: DON'T use the Array(args) trick to autopromote single objects to
# an array and then treat the method like it can receive a single element OR an
# array, because it CAN'T. In this instance, args will ALWAYS be promoted to one
# more level of array than the caller sent.
require 'pry'



def lines
  $lines ||= IO.readlines(__FILE__).map(&:strip)
end

def print_caller_source
  # Here's a fun thing. caller[0] is the thing that called us. But here we are
  # extracting printing the caller to its own method, and when you call THIS
  # method, caller[0] from in here is the place where you called this method,
  # which means that in here we need to look at caller[1].
  #
  # To make matters worse, if you try to loop over, say, the first 3 callers
  # to print them one at a time, caller will gain another stack frame because
  # the loop body is a block, so caller[0] will now point at the 3.times do
  # line.
  #
  # This isn't weird, this is just how ruby rolls.
  #
  # You can short-circuit all of this by passing your binding in with the
  # original call, but where's the fun in that?
  puts "  Called: #{lines[line_index_from_backtrace(caller[1])].sub(/^app./,'')}"
end

def line_index_from_backtrace(trace)
  trace.split(/:/)[1].to_i - 1
end

def print_line
  puts "-" * 80
end

def how_many(*args)
  print_line
  print_caller_source
  puts "Received: how_many(#{args.inspect})"
  if args.respond_to? :length
    puts "  args.length: #{args.length}"
    if args.respond_to? :first
      puts "  args.first: #{args.first}"
      if args.first.respond_to? :length
        puts "    First object length: #{args.first.length}"
      else
        puts "  args.first does not respond to #length"
      end
    else
      puts "  args does not respond to #first"
    end
  else
    puts "  args does not respond to #length"
  end
end

def run!
  how_many(3)
  how_many(1,2,3)
  how_many([1,2,3])
  how_many([1,2,3], 4)
  how_many([1,2,3], [4,5,6])
  how_many([1,2,3], [4,5,6], 7)
  print_line
end

if __FILE__==$0
  run!
end
