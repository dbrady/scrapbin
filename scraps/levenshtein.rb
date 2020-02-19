class String
  # Calculate the "edit distance" between two strings (Levenshtein distance)
  # d(i, j) = min(d(i-1, j)+1, d(i, j-1)+1, d(i-1, j-1) + r(s(i), t(j)))
  #
  # Examples:
  #
  # "foo".edit_distance_to "bar"
  # # => 3
  # # The edit distance is 3, because all 3 characters must be changed
  # to complete this edit.
  #
  # "dave".edit_distance_to "david"
  # # => 2
  # # The edit  distance here is 2, because the e must be changed, and
  # an additional character added.
  #
  # "How many roads must a man walk down".edit_distance_to("before you call him a man?")
  #
  # NOTE! This is an INSANELY recursive function that executes in
  # exponential time. Use it on short strings only, please! Execution
  # time for 1k strings is on the order of 3-8 seconds--and even then
  # ONLY if they are very close. 256b strings are below 1s; short
  # strings are very fast. (Times are on a dual-core 2.5GHz machine
  # with 4GB of RAM)
  #
  # WARNING: For very disparate strings, the exponent grows VERY quickly. A
  # 12-character string with an edit distance of 12 (completely different
  # strings) takes over an hour on a 2010-era machine.
  #
  # "abcdefghijklm".edit_distance_to("nopqrstuvwxyz")
  #
  # The execution time on my 2.6GHz, dual-core MBP was 68m 25s.
  def edit_distance_to(s)
    if empty?
      s.length
    elsif s.empty?
      length
    else
      [(self[0]==s[0] ? 0 : 1) + self[1..-1].edit_distance_to(s[1..-1]),
      1 + s.edit_distance_to(self[1..-1]),
      1 + edit_distance_to(s[1..-1])
      ].min
    end
  end
end

if $0 == __FILE__
  # Don't run this, it'll need 17 heat deaths (just kidding, it'll blow stack)
  # puts "How many roads must a man walkdown".edit_distance_to("before you call him a man?")

  # Do run this, it's a less destructive problem
  puts "Mike".edit_distance_to("Mark")
  # => 3
  # TODO: Would be nice to see the actual edits. Levenshtein is smart enough to
  # do it either of two ways:
  # 1. "Mike".change(1, "a")
  #    # => "Make"
  #    .change(2, "r")
  #    # => "Mare"
  #    .change(3, "k")
  #    # => "Mark"
  # 2. "Mike"
  #    .change(1, "a")
  #    # => "Make"
  #    .insert(2, "r")
  #    # => "Marke"
  #    .delete(4)
  #    # => "Mark"
end
