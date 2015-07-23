#!/bin/bash
# Happy Numbers Annoying: Print 1 to 100 plus -> HAPPY or -> UNHAPPY.
#
# Annoying because it loops until next_happy() returns 1 or 42, WHICH ALWAYS HALTS FOR ALL NATURAL NUMBERS
ruby -e 'def next_happy(n); n.to_s.split(//).map {|n| n.to_i**2 }.reduce(:+); end; (1..100).each {|j| i=j; i=next_happy(i) until [42,1].include?(i); puts "#{j} -> #{i == 42 ? %q(UNHAPPY) : %q(HAPPY)}" }'
