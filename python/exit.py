#!/usr/bin/env python
import sys

# tl;dr use sys.exit(int)

# (unless you're exiting from a child process you created with
# os.fork(), in which case you probably already know what you're
# doing and that you might want os._exit(int) instead.)

# There are four ways to quit Python:

# 1. quit() - Do not use. It's in the site.py module, which may not be
#    available if you do not control the deployment. (The Python
#    zeitgeist seems to still be to generally assume that your code
#    may be run on a foreign system without any kind of virtualenv or
#    requirements.txt.)

# 2. exit() - Do not use. Same reason.

#    HOWEVER. If you DO control the deployment, this is the easiest one to use
#    and that might be okay. Hello from the post-Docker era.

# 3. sys.exit(int) - Standard way to cleanly exit from the main
#    program. Cleans up handlers, closes files, flushes I/O buffers,
#    etc.

# 4. os._exit(int) - Standard way to quickly exit from a child process
#    created with os.fork(). Also works from the main program, but
#    it's quick and brutal, without cleanup like flushing I/O.

sys.exit(0)
