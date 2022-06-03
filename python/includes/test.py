#!/usr/bin/env python

# include test:

# put folder1 and folder2 into the sys.path, and see if both of these work:

# from foo import Foo
# from foo import FooToo

# import sys

# Okay, this works, but doesn't:
#
# from folder1 import foo # for Foo
# from folder2 import foo # for FooToo
#
# The second import replaces the first. FooToo is visible, but Foo is not.
# f = foo.Foo('Foo')


# ...and that lets me predict what the sys.path equivalent would do: the first
# module it finds in the path it will be loaded and will replace any currently
# loaded module of the same name.

# If THAT works, put a Foo class in BOTH files and see what happens...

# It would work fine, but the second would replace the first.
