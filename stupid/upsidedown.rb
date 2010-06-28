#!/usr/bin/env ruby

src = "abcdeghijlmnopqrstuvwxyz"
dst = "Vq)p36y!flwuodbjsLnAmxhz"

msg = ARGV[0].downcase

raise "Sorry, can't translate f's or k's." if msg =~ /(f|k)/

msg2 = msg.split(//).map {|ch| idx = src.index(ch); idx.nil? ? ch : "%c" % dst[idx]} * ''

puts msg2.reverse

