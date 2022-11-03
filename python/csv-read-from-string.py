#!/usr/bin/env python

# tl;dr: Python's CSV functions all want to read from filehandles. What do?

# 1. split the string into an array of strings and hopework.

# 2. Spoonfeed the complier by using io.StringIO to turn that string into an io
# buffer.
import csv

data = """
id,name,size,color
1,Standard Widget,13mm,blue
2,XL Widget,19mm,blue
3,Inaccurately-Named Green Widget,22mm,red
"""
print("Reading CSV from a string")

print("-" * 80)
print("Method 1: split the string into an array of strings and hopework.")
reader = csv.reader(data.split("\n"))
for row in reader:
    print(row)

from io import StringIO

print("-" * 80)
print("Method 2: Wrap the string in a StringIO object and read from its buffer.")
reader = csv.reader(StringIO(data))
for row in reader:
    print(row)
