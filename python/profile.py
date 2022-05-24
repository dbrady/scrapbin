#!/bin/bash
# How to profile Python
# tl;dr it's not very good... :-(

# See Stack Overflow for this very cool 2-step of going from script.py to a call graph image:
# https://stackoverflow.com/questions/4544784/how-can-you-get-the-call-tree-with-python-profilers
#
# 0. install gprof2dot
# easy_install gprof2dot # TODO: easy_install was present on my Debian box, investigate. Newer than apt. Better?
#
# 1. generate a profile stats file
# python -m cProfile -o myLog.profile <myScript.py> arg1 arg2 ...
#
# 2. Convert it into a dotfile
# gprof2dot -f pstats my_log.profile -o call_graph.dot
#
# 3. open with GraphViz to view the graph, or run my dot2png script to go straight to an image file
# dot2png call_graph.dot
# open call_graph.png
