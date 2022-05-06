#!/usr/bin/env python

# ./argf-read-from-stdin-or-file.py file1 file2
# cat file1 | ./argf-read-from-stdin-or-file.py

# note that you need strip out non-file args from sys.argv
import fileinput, sys
for line in fileinput.input(sys.argv):
    print(line.rstrip())
