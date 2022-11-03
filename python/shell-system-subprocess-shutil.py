#!/usr/bin/env python
# Running shell commnads and crap

with open("test.dat", "w") as file:
    file.write("Hello Python World\n")

# "How do I copy a file in python?"

# First, there's a library function for that, but it is not generalizable to
# shell commands and also does not copy all file attributes, potentially making
# it a poor solution to the problem it purports to solve.
#
# Also if you want to delete a file, you want os.remove() rather than a peer
# function in shutil.
import shutil

shutil.copyfile("test.dat", "test2.dat")


# Or you can use os.system() to run a bash command.
#
# Note: this is considered an "older" way to do it and Python peeps suggest
# upgrading to subprocess.run wherever possible.
import os
os.system("cp test.dat test3.dat")

# And lastly, subprocess.run works like an extended subset* of popen3 and the
# backtick operator from other langs. Python do be doin' its own thing tho, so
# you have to pass in a stdin object and receive back a CompletedProcess object
# that has the stdout/stderr output on it.
#
# Note that while you can pass in a single string as the first arg, you cannot
# pass in a string containing the whole command. Arguments MUST be passed in as
# args[1:]. run("rm test4.dat") will fail because there is no program called
# "rm\ test4.dat".
#
# Also note that CompletedProcess.stdout is a byte sequence, not a string. If
# you want a string, you gotta decode it.
#
# * heh.
import subprocess
completion = subprocess.run(["cp", "-v", "test.dat", "test4.dat"], capture_output=True)

print(completion.stdout.decode("UTF-8"))

os.remove("test.dat")
os.remove("test2.dat")

os.system("rm test3.dat")

subprocess.run(["rm", "test4.dat"])
