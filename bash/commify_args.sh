#!/bin/bash

# This is just a clever little hack to insert commas into a list iteratively in
# bash. The trick is to have the glue character unset the first time through.
#
# The first time through the loop, both $args and $glue expand to empty
# strings, so files accumulates only the first arg. Each loop thereafter
# accumulates the next arg with the comma.

# commify args. `git add-new a b c d` -> "a, b, c, d"
# first time through loop, args and glue expand to empty string.
for i in $@; do
    args="$args$glue$i"
    glue=', '
done

echo $args
