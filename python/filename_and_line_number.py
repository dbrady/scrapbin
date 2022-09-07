#/usr/bin/env python

# This answer looks clean but actually raises an import error, at least on
# Python 3.9.12, but it DOES work on python 3.7.13, which is what matters in
# dataservices' Docker

# Ruby: puts "This is line #{__LINE__} in file #{__FILE__}"
# tl;dr how do I __FILE__ and __LINE__ in Python?

# Stack Overflow:
# https://stackoverflow.com/questions/3056048/filename-and-line-number-of-python-script
# But this
from inspect import currentframe, getframeinfo

frameinfo = getframeinfo(currentframe())

print(frameinfo.filename, frameinfo.lineno)


import inspect

print(f"lineno: {inspect.getframeinfo(inspect.currentframe()).lineno}")
