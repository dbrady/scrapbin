#!/usr/bin/env ruby
# merge_override.rb - override one hash/array with another
# hashes work like Rails deep_merge
# arrays work like hashes of position => value
#
# Having arrays in the mix means you can have an array of hashes and deeply
# override each of them positionally:
#
# [{a: 1, b: 2}, {a: 42, b: 13}].override([{b:0},{a:55},{a:44,b:44}]
# => [{a: 1, b: 0}, {a: 54, b: 13}, {a: 44, b: 44}]

# tl;dr if the object is a hash, merge each_pair, otherwise merge each.with_index.

class DeepMergeOverrider
  def merge_override(obj1, obj2)
  end

  private

  def array_merge_override(ray1, ray2)
  end



def
end


if __FILE__==$0
  # TODO: Go find the "how to run minitest from inside a single file" thing and
  # jam out the test cases here

  # merge_override on a shallow hash works exactly like Hash#merge
  hash1 = {a: 5, b: 7, c: 19 }
  hash = merge_override(hash1, {b: 4})
  # hash should == {a: 5, b: 4, c: 19}

  ray1 = [1, 2, 3]
  ray = merge_override(ray1, [nil, 5])
  # ray should == [1, 5, 3]

  # override with growing/inserting new fields
  hash = merge_override(hash1, {d: 5})
  # hash should == {a: 5, b: 7, c: 19, d: 5}
  ray = merge_override(ray1, [nil, nil, nil, 4])
  # ray should == [1, 2, 3, 4]

  # if both values are hashes, or both values are arrays, DON'T CLOBBER
  # THE VALUE -- recurse instead
  hash2 = {a: 5, b: {b1: 1, b2: 2}}
  hash = merge_override(hash2, {b: {b2: 7}})
  # hash should == {a: 5, b: {b1: 1, b2: 7}}

  # if one value is an array and the other is a hash, GO AHEAD AND CLOBBER
  # Or perhaps raise an ArgumentError that the data structures do not match?
  hash = merge_override(hash2, {b: [1, 2]})
  # should raise an error, OR just clobber it, and hash == {a: 5, b: [1, 2]}

  # if both objects are simple objects, return b unless it is nil, in which case, return a
  a = 5
  b = merge_override(a, nil)
  # b == 5
  b = merge_override(a, 7)
  # b == 7
end
