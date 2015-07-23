#!/usr/bin/env ruby
#
# happy_numbers.rb - tell if a number is happy or not.
#
# Usage:
# ruby happy_number.rb [options] [number|range]
#
# number - number to determine happiness for. If omitted, reports on numbers
# 1..100.
#
# range - range of numbers to report on, e.g. 1..10.
#
# options:
#
# --chain - show the chain of numbers, e.g.
# if number is omitted, show numbers 1..100 and their happiness.
#
# --quiet - do not print anything, just return exit status 0 (bash success) if
# number is happy, 1 if it is unhappy.
#
# --test - run test suite
#
# Examples:
#
# ruby happy_number.rb 7
# 7 is happy
#
# ruby happy_number.rb 6
# 6 is not happy
#
# ruby happy_number.rb --chain 7
# 7: 7 49 97 130 10 1
# 7 is happy
#
# ruby happy_number.rb
#   1: Yes
#   2: No
#   3: No
#   ...
#  99: No
# 100: Yes
#
# ruby happy_number.rb --chain 7
# 7: 49 97 130 10 1
#
# ruby happy_number.rb --chain 6
# 6: 36 45 41 17 50 25 29 85 89 145 42 20
#
# ruby happy_number.rb --chain 5..6
# 5: 25 29 85 89 145 42 20
# 6: 36 45 41 17 50 25
#
# ruby happy_number.rb --chain --full 5..6
# 5: 25 29 85 89 145 42 20
# 6: 36 45 41 17 50 25 29 85 89 145 42 20
#
require 'trollop'
opts = Trollop.options do
  banner <<-EOS
happy_number - determine if a given number is happy.
EOS
  opt :test, "Test mode", type: :boolean
  opt :info, "Show extended information", type: :boolean
  opt :chain, "Show chains", type: :boolean
  opt :quiet, "Quiet mode", type: :boolean
end

if opts[:info]
  show_info
  exit 1
end

Trollop::die

require 'minitest/autorun' if opts[:test]

def show_info
  puts <<-INFO

INFO
end


class Integer
  @@happiness = Hash.new {|h,k| h[k] = []}

  def happy?
    self.class.happy?(self)
  end

  def self.happy?(num)
    true
    # if @@happiness.key?(self)
    #   self
    # else
    #   return self.class.happy?(self)
    # end
  end
end

if __FILE__==$0
  if opts[:test]
    class TestHappy < MiniTest::Unit::TestCase
      def test_that_1_is_happy
        assert 1.happy?
      end
    end
  else
    puts "Run!"
  end
end
