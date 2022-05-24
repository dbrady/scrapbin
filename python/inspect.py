#!/usr/bin/env python
# inspect.py - How to do ruby obj.inspect
# Basically I want dir(obj) but from a script, not just the repl.

# long version: go learn you the inspect module.

# tl;dr:
# ruby:   obj.inspect
# python: repr(obj)

d = {"a": 5, "b": 13}

# Option 1: repr()

# repr uses the __repr__ method, which in theory (but often not in
# practice) should give you a string that can be eval()'ed to
# recreate the object. I.e., human-readable string marshaling. Yeah,
# we have that in ruby, too, and it also doesn't work, and for the
# same reasons. Marshaling and human-readable are orthogonal concepts,
# human-readable is hard, and marshaling is easy if you ignore the
# human-readable part. Which is why ruby ended up providing about 5
# other marshaling mechanisms (Marshal.dump, pstore,
# yamlstore/to_yaml, json, etc).
print("repr():")
print(repr(d))
print()

# pprint is nice if you have recursive structures (especially ones
# with cyclic graphs) because you can specify a depth parameter as
# pprint(d, depth=2) etc.
print("pprint():")
from pprint import pprint
pprint(d)
print()

# inspect.getmembers

from inspect import getmembers
getmembers
