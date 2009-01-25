# A Ranglelet is a utility class for condensing ranges and arrays.
# Given an array like [1,2,3,6,7,8,9,11], it will return "1-3,6-9,11".
# 
# I originally wrote this for a project that needed to present a list
# of required questions to a human, on a form that contained 50+
# questions.

class Rangelet  
  attr_accessor :first, :last
  
  def initialize(first,last=nil)
    @first = first
    @last = last || @first
    @first, @last = @last, @first if @first > @last
  end
  
  def to_s
    s = @first.to_s
    s += '-' + @last.to_s if @first != @last
    s
  end
  
  def to_a
    (@first .. @last).to_a
  end
end

module ArrayToRangelet
  # Convert this collection to an array of rangelets.
  def to_rangelets
    a = Array.new(self).sort
    rr = []
    rr << a.shift_rangelet while a.size>0
    rr
  end
  
  # An array of rangelets can be converted into a flattened/expanded array by simply calling to_a on each element.
  def from_rangelets
    self.inject([]) {|a,b| a + b.to_a}
  end

  # Shifts the first contiguous rangelet off the beginning of the
  # collection.
  def shift_rangelet
    return nil if size.zero?
    r = Rangelet.new(shift)
    r.last = shift while size>0 && r.last.succ == self[0]
    r
  end
end

class Array
  include ArrayToRangelet
end

