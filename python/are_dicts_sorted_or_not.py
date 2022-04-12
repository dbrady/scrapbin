#!/usr/bin/env python

# When the customer says "I want to store these names in an ordered
# set or hash," there are two kinds of programmers:
#
# 1. "Sets, by definition, cannot be ordered! Hashes are effectively
# random numbers and their order is undefined!"
#
# 2. "Um, yeah, I can see why storing names without duplicates and
# retrieving them in a defined order would be valuable."

# prior to 3.4, python hash iteration order was undefined, which means
# probably random.

# In 3.5, hash iteration order changed to ALWAYS be random. This made
# certain people exactly as happy as you'd expect and made everyone
# else realize how terrible an idea it was.

# This decision was immediately overturned in 3.6 and subsequent
# versions.  Hashes now always iterate in insertion order. However,
# the ghost of 3.5 and earlier may linger: If you aren't sure which
# version of python your code will run on, you should explicitly
# enforce the retrieval order.

# Right now (Ac, circa Spring 2022) we're using Python 3.7 everywhere, so we get
# ordered hashes, but take care not to dip into features from 3.8, 3.9, or 3.10,
# which is currently the latest.

print("Yes")
print("(...as long as you're sure your code will not be run on 3.5 or earlier.)")
print("(Python 3.5 was End-of-Lifed on September 5, 2020, so here's hoping.)")
