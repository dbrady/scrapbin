class Array
  # Construct a hash of objects, keyed by some object attribute.
  # 
  # Original idea and code by Brian Dainton. Taken from his blog, The
  # Budding Rubyist.
  # http://buddingrubyist.wordpress.com/2008/02/05/why-i-like-to-inject/
  def hash_by(attribute)
    inject({}) do |results, obj|
      results[obj.send(attribute)] = obj
      results
    end
  end

  # Returns a hash whose keys match the attribute and values are arrays.
  # hash_by returns a single element (the last one to match the
  # attribute key), partition_by returns an array of all elements that
  # match.
  # 
  # ["a", "bb", "cc", "ddd", "e"].partition_by :size
  # => {1=>["a", "e"], 2=>["bb", "cc"], 3=>["ddd"]}
  def partition_by(attribute)
    inject(Hash.new {|h,k| h[k]=[]}) do |a,b|
      a[b.send(attribute)] << b
      a
    end
  end
end 
