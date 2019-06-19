# Give it a collection of hashes of arrays of hashes of I don't care.
# Get back a copy of the structure, but with the keys of all hashes sorted, no
# matter where you've tried to hide the little beggars in the structure
def deep_keysort(unruly_collection)
  case unruly_collection
  when Array
    unruly_collection.map {|item| deep_keysort(item) }
  when Hash
    h = {}
    unruly_collection.keys.sort.map {|key| h[key]=deep_keysort(unruly_collection[key]) }
    h
  else
    unruly_collection.dup
  end
end
