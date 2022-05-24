#!/usr/bin/env python

# max_by - return item whose x is the max. I.e. in ruby names.max_by(&:size)
# will return the longest name--the item that is the max, by size.

# This is where python chafes me a bit. Because there are multiple algorithms
# for finding the max_by, and these algorithms have tradeoffs, it follows that
# any provided algorithm must be a poor choice in SOME circumstances and
# therefore Python provides a solution to NONE of them. THIS IS NOT A
# SOLUTION. It's a smug declaration of "well this solution, that would work
# great for many people, might not work for some people, so we're ALL going to
# just sit here in the mud puddle and have a big sadness."

# 15 years ago a lot of programming communities felt that if an algorithm
# "doesn't guarantee" something, it MUST "guarantee doesn't". I.e., if the
# output of f(x) is undefined, the input x must be guarded against. But... this
# is an unqualified statement, and it should be qualified by the IMPACT of the
# undefined behavior. It's one thing to say "executing a jump to an
# uninitialized pointer produces undefined behavior". That will crash your
# computer (or, in modern times, just your program). But it's another thing
# entirely to say "there are two approaches here, one is computationally
# expensive but saves on memory and the other uses lots of memory but is
# computationally efficient, and using one approach when your environment favors
# the other may produce undefined results." No, it doesn't. I does NOT produce
# undefined results! It may produce *undesirable* results, but they aren't
# undefined. It is not the literal antichrist if your program takes centuries to
# finish or runs out of memory when given a very large input. I call that a
# regular Tuesday. The job of a programmer is to identify those problems and fix
# them. Ruby's attitude is "here is a very convenient way of using one of those
# approaches, and if your program misbehaves, identify the problem and roll your
# own replacement."  Python's attitude is "well our approach might misbehave so
# you must always roll your own implementation."
#
# I. JUST. WANT. THE. LONGEST. STRING.
#
# In a program that formats csv files into columns, or a program that manages a
# student roster and shows which student had the highest score on a test,
# hand-rolling a longest-string detector or highest-score detector is a painful
# distraction. (And yes, showing only the first of multiple students sharing the
# high score might be unfair to the other students. Or it might not, maybe you
# just need them for their score, not their name. But this speaks to my point:
# if you have to stop and write a high score locator when you're getting paid to
# write a sliding scale grading algorithm, at best you are spoonfeeding the
# compiler and at worst your language is actively thwarting you.)


def max_by(collection, transform_function):
    """ Return item in collection where transform_function(item) is the maximum.

    E.g. max_by(names, len) would return the longest name.

    If more than 1 item shares the maximum transform value, returns the first
    one.
    """
    if len(collection) == 0:
        return None

    max_value = transform_function(collection[0])
    max_item = collection[0]

    for item in collection[1:]:
        this_value = transform_function(item)
        if this_value > max_value:
            max_item = item
            max_value = this_value

    return max_item

# BONUS! Here's min_by. It differs by 1 character. There is a temptation to DRY
# this up, but I suspect that will just CHAFE
def min_by(collection, transform_function):
    """ Return item in collection where transform_function(item) is the minimum.

    E.g. min_by(names, len) would return the shortest name.

    If more than 1 item shares the minimum transform value, returns the first
    one.
    """
    if len(collection) == 0:
        return None

    min_value = transform_function(collection[0])
    min_item = collection[0]

    for item in collection[1:]:
        this_value = transform_function(item)
        if this_value < min_value:
            min_item = item
            min_value = this_value

    return min_item
