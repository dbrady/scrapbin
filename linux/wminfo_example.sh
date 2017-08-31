#!/bin/sh

# this script taken from https://superuser.com/questions/153196/create-keyboard-shortcuts-to-move-resize-windows-in-ubuntu

# Florian Diesch submitted this with an explanation, which I will reproduce here
# in my own words because learning.

# xwininfo -root gets a bunch of stats about the current desktop. Run it and
# you'll see the output includes, e.g. "Width: 3840" and "Height: 2160".

# awk parses the output and emits just the numbers. xwininfo gives width first,
# so that's the first number, so the output above would just come out as
# 3840
# 2160

# set -- (stuff) takes one argument per line and sets them to $1, $2 etc. These
# are then assigned to $width and $height for clarity.

# wmctrl is a window manager control. man wmctrl for LOTS of cool stuff. In this
# case, however:
# -r means specify the window that is the target of the operation
# :ACTIVE: is the target - the currently active window
# -e means resize the target window
# The next args are a single string containing 5 numbers separated by commas.
# - the first number sets or selects the gravity of the window. Gravity is
# nontrivial and not entirely clear; until you understand it just put 0.
# - Next 4 args are left, right, width, height
# - send -1 to not change the existing value
#
# so x,y,-1,-1 would move a window without resizing it
#
# xwininfo returns the size of the entire logical desktop, so beware if you're
# running dual monitors.
#
# Other fun detail: $((width*90/100)) totally works in *sh*, not just bash
set -- $(xwininfo -root| awk -F '[ :]+' '/ (Width|Height):/ { print $3 }')
width=$1
height=$2

wmctrl -r :ACTIVE: -e 0,-1,-1,$((width*90/100)),$((height*90/100))
