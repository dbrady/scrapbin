#!/usr/bin/env ruby -w
# You can refactor code of the form
#
# allocate_resource
# loop on resource
# free resource
#
# into the form
#
# each_resource {|resource| ... }
#
# without fear of memory leaks if you put a begin/ensure block in the generator, like so:

def repeater(x)
  begin
    rid = rand(100)
    puts "ALLOCATION: Resource id #{rid} allocated."
    x.times do |i|
      yield i
    end
  ensure
    puts "FREE: Resource id #{rid} has been freed."
  end
end

puts "-" * 80
puts "Normal Operation:"
repeater(5) do |y|
  puts "Repeater yielded to me the number #{y}."
end

puts "-" * 80
puts "Breaking out of the loop:"
repeater(5) do |y|
  puts "Repeater yielded to me the number #{y}."
  if y==3
    puts "Whoa, whoa. y was 3. We're outta here."
    break
  end
end

puts "-" * 80
puts "Raising an exception out of the loop:"
repeater(5) do |y|
  puts "Repeater yielded to me the number #{y}."
  if y==3
    puts "Whoa, y was 3. I'm raising an ArgumentError!"
    raise ArgumentError, "y was 3!"
  end
end
puts "-" * 80

puts "All done."
