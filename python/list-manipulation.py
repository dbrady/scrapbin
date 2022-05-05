#!/usr/bin/env python

# Here's a quick attempt at a rosetta between ruby's Enumerables and python's Lists

# Python lists have a very small surface area:

# - list.+(other) - works the same in both languages. a + b returns a new list
#   concatenating the two lists.

# - list.+=(other) - works the same in both languages. a + b concatenates b onto
#   a and returns the newly-modified a.

# - list.append(item) - same as ruby's ray.push(item). Adds item to the end of
#   list. It is identical to list.insert(len(list), item). All the other methods
#   that are equivalent to insert do NOT exist, you have to just use insert. Go
#   figure.

# - list.extend(iterable) - same as ruby's ray.concat(enumerable) or
#   list.+=(enumerable).

# - list.insert(before_index, item) - inserts item before index. Pretty much
#   every other way of putting an item into a list in python is done through
#   this method. Ruby's prepend/unshift would be list.insert(0, item). Returns
#   None - Python's design principle for mutable data structures is to make
#   commands unchainable. (C.f. ruby's "don't chain bang methods"). Ruby's push
#   method would be list.append(item), but if append didn't exist you could do
#   the same thing with insert(len(list), item).

# - list.remove(item) - SIMILAR BUT NOT THE SAME as ray.delete(item) or ray -
#   [item]. Removes the FIRST element that matches item, as opposed to removing
#   ALL items that match item, as in ruby. Can also be done with del
#   list[index], which isn't even legal python what. Note that del works on
#   ranges, e.g. del ray[1:3]. Raises ValueError if list does not contain
#   item.

# - list.pop([index]) - Removes item at index, or from the end of the
#   list if no index is given. Differs from del by return value (pop
#   returns the item, del returns None)

# - list.clear() - Removes all items from the list. Equivalent to del list[:]

# - list.index(item[, start[, end]]). list.index(item) is the same in ruby,
#   returns the index of the first element equal to item. Start and end work
#   like slice notation, limiting the search range. list.index(3,1,2) and
#   list[1:2].index(3) return different indexes--the first case indexes into the
#   whole array from the given boundaries, whil the second case uses the
#   boundaries to return a smaller array and index into that. Raises ValueError
#   if no item is found.

# - list.count(item) - same as ruby

# - list.sort(key=None, reverse=False) - Umm, let me get back to you. Sorting is
#   a whole thing in Python (much like ruby). key is a function pointer to a
#   method that can receive an item from the list and return a transformed
#   value, e.g. list.sort(key=str.lower) is similar to list.sort_by(&:downcase),
#   the difference being str.lower is a function pointer, so it calls
#   str.lower(item) on each element, while downcase is a proc, so it sends the
#   downcase message to each element.

# - list.reverse() - same as ruby

# - list.copy() - identical to ruby's ray.dup. Makes a shallow copy.

# THINGS I USE IN RUBY THAT DON'T EXIST IN PYTHON:

# ray.shift - list.pop(0)

# ray.unshift(item) - list.insert(0, item)

# ray.push(item) - list.append(item)

# ray.include?(item) - "item in list".
