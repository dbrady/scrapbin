#!/usr/bin/env ruby
#
# Stupid idea for a DSL to annotate 7- and 14-segment LED displays.
#
# B = a b c d n e s
#
# Wait, what?
#
# A 14-segment LED display has, well, 14 segments. The outer ring are labeled
# a-f, with the top being a and going clockwise. On a 7-segment display the
# crossbar of the digit is called g. On a 14-segment display, the inner segments
# are labeled starting at the top-right angle bar and proceeding clockwise again
# until reaching the top-center ray. Letters l and o are skipped because they
# are visually ambiguous, so the rays go from g to p.


# Another labeling scheme is to call the outer ring by their position: t for
# top, tr for top right, br for bottom right, then b, bl, and tl. The cross bar
# would be called c for center (or crossbar). For the 14-segment display, the
# center star can be referenced by the direction the "ray" moves going out from
# the center, e.g. g = ne, h = e, j = se, k = s, and so on.

# If the DSL is written so that s() returns a new Segment object with the South
# segment turned on, and s(seg) returns a copy of the passed-in Segment object
# with the South segment turned on, then a b c d n e s works out to
# a(b(c(d(n(e(s())))))), which should look like this:
#
# _ _
#  |_|
# _|_|
#
# Aaaand BOOM. There you go.
def Segment
  A = 1
  B = 2
  C = 4
  D = 8
  E = 16
  F = 32
  G = 64
  H = 128
  J = 256
  K = 512
  M = 1024
  N = 2048
  P = 4096

  def initialize(segments=0)
    @segments = segments
  end

  def s(seg=Segment.new)
    Segment.new seg.segments + SOUTH
  end
end

def s
  Segment.new.s
end

# As a perverse bonus, this mean we also support this syntax:
#
# M = Segment.new.b.c.e.f.ne.nw
