#!/usr/bin/env ruby

# Quick program to see how much more expensive it is to use
# attr_accessor than to access an ivar directly, and to see if marking
# an accessor as private makes any performance difference.

# Run it yourself, or see my timing output below. Or, for the TL;DR:
# - attr_accessor is about 3% slower than using an ivar
# - a private attr_accessor is also about 3% slower (interesting: it's
#   closer to 4% in short runs; I suspect method caching may be afoot)
# - writing an accessor method in ruby that accesses an ivar is 32-34%
#   slower than accessing the ivar (If you are refactoring an ivar to
#   a derived expresison, this is unavoidable and you will also incur
#   the cost of the expression. The 32-34% is just the cost of
#   invoking an accessor written in pure Ruby rather than letting
#   attr_accessor optimize it for you)

require 'benchmark'
include Benchmark

class Poohat
  attr_reader :poo
  private
  attr_reader :hat
  public

  def initialize(poo, hat)
    @poo, @hat = poo, hat
  end

  def public_poo
    @poo
  end

  def public_hat
    @hat
  end

  def benchmark!(opts = {})
    puts "Benchmarking ivars vs attr_accessors vs explicit accessors"
    n = opts[:n] || 100_000_000

    bmbm(21) do |x|
      x.report("ivar") { n.times { @poo } }
      x.report("attr_accessor") { n.times { poo } }
      x.report("private attr_accessor") { n.times { hat } }
      x.report("explicit pub->prv") { n.times { public_hat } }
      x.report("explicit pub->pub") { n.times { public_poo } }
    end
  end
end

# ----------------------------------------------------------------------
# MAIN SCRIPT
# ----------------------------------------------------------------------
p = Poohat.new 42, 69
args = ARGV[0] ? {n: ARGV[0].to_i } : {}
p.benchmark! args


# ----------------------------------------------------------------------
# END MAIN SCRIPT - My sample output follows
# ----------------------------------------------------------------------

# Recorded with a 1.9GHz Core i7 CPU on 2013-04-22 (ASUS UltraBook)

# $ ruby accessor_test.rb
# Benchmarking ivars vs attr_accessors vs explicit accessors
# Rehearsal ---------------------------------------------------------
# ivar                    5.510000   0.000000   5.510000 (  5.519713)
# attr_accessor           5.880000   0.000000   5.880000 (  5.895158)
# private attr_accessor   5.900000   0.000000   5.900000 (  5.904210)
# explicit pub->prv       7.830000   0.000000   7.830000 (  7.844384)
# explicit pub->pub       7.830000   0.000000   7.830000 (  7.838767)
# ----------------------------------------------- total: 32.950000sec
#
# user     system      total        real
# ivar                    5.510000   0.000000   5.510000 (  5.522235)
# attr_accessor           5.930000   0.000000   5.930000 (  5.939281)
# private attr_accessor   5.900000   0.000000   5.900000 (  5.907319)
# explicit pub->prv       7.830000   0.000000   7.830000 (  7.843047)
# explicit pub->pub       7.850000   0.000000   7.850000 (  7.858027)
