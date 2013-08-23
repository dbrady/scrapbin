#!/bin/bash

# getopts is a bash shell builtin for bash to process command-line
# options. (note the s; this is NOT 'getopt', which is an external
# program)

# Much of my demo notes here are taken with much gratitude from
# http://wiki.bash-hackers.org/howto/getopts_tutorial

# getopts OPTSTRING VARNAME [ARGS...]
#
# OPTSTRING - a little encoded string specifying the parameters you
#     want to handle
# VARNAME - tells getopts which shell variable to use for option
#     reporting
# ARGS - (optional) tells getopts to parse these words instead of the
#     positional params passed in to the script

# getopts chomps one argument at a time from the arglist and stores it
# in VARNAME, which you can then access as $VARNAME. If you expect to


while getopts ":ai:o:" opt; do
  case $opt in
    a)
      # Log these messages to stderr so they don't get captured as
      # part of our "real" output
      echo '-a flag has been set!' >&2
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
