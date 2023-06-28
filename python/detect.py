#!/usr/bin/env python

# Let's say we have a list of hashes, and we want to find the first element that
# has role == owner.
#
# In ruby this is ray.detect {|r| r["role"] == "owner" }
#
# Here is the equivalent python:
#
# owner = next((p for p in perms if p["role"] == "owner"), None)

# (p for p in perms if p["role"] == "owner") is equivalent to perms.filter {|p| p["role"] == "owner" }
#
# ruby will return an Array, python returns an iterator.
#
# At this point the paradigms diverge; python's next(iterator, None) grabs the
# first element from the iterator, defaulting to None if not found. See ruby's
# feetch otherwise it will raise an StopIteration exception (analogous to ruby's
# Hash#fetch raising KeyError without a default).

# In ruby we could make a proper iterator and yield into it, but that's a lot of
# work to match the python implementation with zero benefit in behavior. We
# could use filter to get the Array and call .first on it; that gives up the
# ability to iterate deeper into the collection but since python tosses away
# that feature, it is unnecessary. No, what we have is a collection and a block
# and we want the first thing that responds, and that is literally the whole
# point of Enumerable#detect. It's its entire raisin deeter.

ray = [
  {"name": "Alice", "role": "user"},
  {"name": "Bob", "role": "owner"},
  {"name": "Carol", "role": "owner"},
  {"name": "Dave", "role": "user"}
]

# Python
print(next((p for p in ray if p["role"] == "owner"), None)
# print(ray[0])
# print("\n")

# Ruby
# puts ray.first
# puts((ray.filter {|p| p[:"role"] == "owner" }).class)
