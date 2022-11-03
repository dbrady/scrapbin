#!/usr/bin/env python

# TL;dr it's this nonsense:
# expandvars will expand $HOME (and any/all other vars)
# expanduser will expand ~/ and ~username
os.path.expandvars(os.path.expanduser("$HOME/pants"))
os.path.expandvars(os.path.expanduser("~/pants"))
os.path.expandvars(os.path.expanduser("~david.brady/pants"))

# Ruby:
# dirname = File.dirname(__FILE__)
# filename = File.join(dirname, 'relative/path/to/file')
# abspath = File.expand_path(filename) # also expands ~ into e.g. /home/you or /Users/you

# Python:
import os
dirname = os.path.dirname(__file__)
filename = os.path.join(dirname, 'relative/path/to/file') # poor, won't work on Windows because \\ != /
filename = os.path.join(dirname, 'relative', 'path', 'to', 'file') # better
abspath = os.path.abspath(filename)

print("Here, learn you a good python:")
print(f"__file__: {__file__}")
print(f"dirname: {dirname}")
print(f"filename: {filename}")
print(f"abspath: {abspath}")

# note that abspath returns a relative path (wat).

# os.path.expandvars will expand $HOME but not ~, lol/sigh.

# os.path.join takes a variable arg list, which should be favored over
# a string containing linux path separators, which might not work on
# Windows. Another nod to Python's mindset of "your code should
# support your user's environments" over Ruby's "your users must
# support your code's requirements". I'm thrilled to see virtualenv
# and pip -r requirements.txt and such, but it sometimes feels like
# people out there are favoring "your code should spoonfeed the
# runtime" over "the runtime must support your code".

# Blog this, maybe? Python recognized this problem was very hard to
# solve and pushed it onto code authors to minimize their
# dependencies, leaving the darker corners of the unsolvable problem
# unaddressed beyond the occasional lament. Ruby declared this problem
# unsolvable and threw it onto the community. It was a complete
# nightmare, orders of magnitude worse than "DLL Hell". And then the
# ruby community said "wow this sucks, and running on an arbitrary
# environment is an impossible problem, but fixing the environment is
# a problem that is merely very difficult." So they invented
# rvm/chruby/rbenv, and then bundler. Because Ruby places no value on
# spoonfeeding your runtime, they place very high value on making it
# trivial to declare, identify, and satisfy requirements. A decade
# later, all the other langs out there are getting on board with
# virtual envs and the ones that aren't get stuffed into a docker
# container.
