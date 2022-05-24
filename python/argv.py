#!/usr/bin/env python

# tl;dr just remember len(sys.argv) is always at least 1 because sys.argv[0] contains __file__

# python argv.py foo bar baz
#  0: ./argv.py
#  1: foo
#  2: bar
#  3: baz

# ./argv.py foo bar baz
#  0: ./argv.py
#  1: foo
#  2: bar
#  3: baz

import sys


i = 0

for arg in sys.argv:
    print(f"{i:2d}: {arg}")
    i += 1
