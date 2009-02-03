module Enumerable
  # [1,2,3,4,5].any_with_index? {|item, index| index == 3 } # => true
  def any_with_index?(&block)
    each_with_index do |item, idx|
      return true if yield(item, idx)
    end
    return false
  end
end

