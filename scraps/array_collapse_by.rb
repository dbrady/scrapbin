class Array
  # Returns an array of 2-element arrays, where the first element is the index
  # attribute and the second is an array of all the array elements matching
  # that attribute. Think of it as hash_by but returning an array of arrays.
  # 
  # ["foo", "a", "bar", "ab", "baz"].collapse_by(:size)
  #  => [[3, ["foo", "bar", "baz"]], [1, ["a"]], [2, ["ab"]]]
  def collapse_by(attrib)
    indices = []
    objects = Hash.new {|hash,key| hash[key] = []}
    self.each do |item|
      key = item.send(attrib)
      indices << key unless objects.key? key
      objects[key] << item
    end
    indices.map {|attrib| [attrib, objects[attrib]]}
  end
end
