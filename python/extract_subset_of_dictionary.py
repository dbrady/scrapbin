#!/usr/bin/env python
# from Python Cookbook 1.17

# tl;dr use a comprehension with a selector like so: subset = { key:value for key, value in dict.items() if ... }

print("# TL;dr")
print("subset = { key:value for key, value in dict.items() if <condition> }")

print("Let's find all the names with 'son' in their surname from this list:")
dict = {"Alice":"Johnson", "Bob":"Dabson", "Carol":"Brady","Dave":"Johnson", "Eddie":"Sondheim"}
print(dict)

print("subset = { key:value for key, value in dict.items() if 'son' in value.lower() }")
subset = { key:value for key, value in dict.items() if 'son' in value.lower() }
print(subset)
