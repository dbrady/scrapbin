#!/usr/bin/env python

# sorting - Python notes

# list.sort() will modify the list in place
# sorted(list) will duplicate list and return it sorted

# both methods can take a key= argument that "a function (or other
# callable) to be called on each list element prior to making
# comparisons".

# so a tighter way of implementing min_by and max_by might be
# sorted(list, key=fn)[0] / [-1]. This is a good example of saying
# "screw you" to the memory in exchange for tighter code. It's 2022,
# we all have 32GB of RAM and 4GHz processors. If you need O()
# notation you already know who you are.
