class Array
  # Yields the array in a chain of pairs, e.g. [1,2,3,4] would be
  # yielded as [1,2], [2,3], [3,4]. Note that at each step, the first
  # element is the same as the last element of the previous iteration.
  # This is useful for, e.g. walking line segments defined as a
  # sequence of points. If cyclic is true, the last element yielded
  # will be the [last, first] elements of the array.
  def each_pair(cyclic=false)
    if size>1
      (size-1).times {|i| yield [self[i], self[i+1]] }
      yield [self[-1], self[0]] if cyclic
    end
  end
end 
