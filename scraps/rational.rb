class Rational
  attr_accessor :numer, :denom
  
  def initialize(n, d)
    @numer = n
    @denom = d
  end
  
  def +(o)
    if o.is_a? Rational
      if @denom==o.denom
        Rational.new(@numer+n.numer, @denom)
      else
        # returning to lowest terms is left to the reader. This proof of
        # concept is for whether or not we can even execute this code, not if
        # the code is right.
        Rational.new(@numer*o.denom + o.numer*@denom, @denom*o.denom)
      end
    elsif o.is_a? Numeric
      Rational.new(@numer+(o*@denom), @denom)
    end
  end
  
  # If a method gets called like 3 + r, and Fixnum can't handle 3.+(Rational),
  # it will call coerce on the argument. coerce must return a pair of objects:
  # the first is the new receiver, and the second is the argument (which is
  # usually unmodified)
  def coerce(other)
    if other.is_a? Numeric
      [Rational.new(other, 1), self]
    else
      puts "(Rational failed to coerce object of type #{other.class})"
      super
    end
  end
  
  def to_s
    "<Rational #{@numer}/#{@denom}>"
  end
end
  
  
if $0 == __FILE__
  r = Rational.new(2, 3)
  puts r
  puts r + 3
  puts 3 + r
end