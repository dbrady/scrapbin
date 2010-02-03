class String
  # Calculate the "edit distance" between two strings (Levenshtein distance)
  # d(i, j) = min(d(i-1, j)+1, d(i, j-1)+1, d(i-1, j-1) + r(s(i), t(j)))
  # 
  # NOTE! This is an insanely recursive function that executes in
  # exponential time. Use it on short strings only, please! Execution
  # time for 1k strings is on the order of 3-8 seconds. 256b strings
  # are below 1s; short strings are very fast. (Times are on a
  # dual-core 2.5GHz machine with 4GB of RAM)
  def edit_distance(s)
    if empty?
      s.length
    elsif s.empty?
      length
    else
      [(self[0]==s[0] ? 0 : 1) + self[1..-1].distance(s[1..-1]),
      1 + s.distance(self[1..-1]),
      1 + distance(s[1..-1])
      ].min
    end
  end
end
