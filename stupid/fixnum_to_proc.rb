#!/usr/bin/env ruby
class Fixnum
  def to_proc
    Proc.new {|arg| arg * self}
  end
end


puts [1, 2, "foo" ].map(&3)
# => [3, 6, "foofoofoo"]
