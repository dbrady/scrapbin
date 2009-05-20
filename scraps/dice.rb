#!/usr/bin/env ruby

srand Time.now.to_i

class Dice
  attr_accessor :sides
  
  def initialize(sides)
    @sides = sides
  end
  
  def roll
    rand(@sides) + 1
  end
  
  def *(a)
     (1..a).map {|d| roll }.inject {|x,y| x+y}
  end
  
  def coerce(a)
    [self, a]
  end
  
  def to_s
    roll
  end
end

# def d6
#   Dice.new(6)
# end

module Kernel
  alias :orig_method_missing :method_missing
  
  def method_missing(symbol, *args)
    if symbol.to_s =~ /^d(\d+)$/
      Dice.new $1.to_i
    else
      orig_method_messing symbol, *args
    end
  end
end 

puts d6 * 3

puts 3*d6 + 3

puts d100.roll

