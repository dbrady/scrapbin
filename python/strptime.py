#!/usr/bin/env python
from dateutil import parser
import sys # for sys.argv

# parser.parse() aims to be "very forgiving" (dwim). For all the formats, see:
# https://dateutil.readthedocs.io/en/stable/parser.html

timestamp = '2022-02-02'

if len(sys.argv) > 1:
    print("Grabbing sys.argv as {time!r}".format(time=sys.argv[1]))
    timestamp = sys.argv[0]

date = parser.parse(timestamp)

print(date.strftime("%F %T")) # %F = %Y-%m-%d and %T = %H:%M:%S
