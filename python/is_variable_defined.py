#!/usr/bin/env python

# Checking if a variable is defined

# Per the Cookbook, just use it and catch the NameError. This is
# particularly good if a variable might be declared locally OR
# globally from outside.

def test():
    try:
        x
        print("x is defined in test()")
    except NameError:
        print("x is NOT defined in test(), but we caught the NameError.")

test()

# A couple of more modern sites suggest checking the locals()
# hash. (There's also a globals() hash, which we would need to detect
# a global variable declared outside of our scope.)

def test2():
    if 'x' in locals():
        print("x is defined locally in test2()")
    else:
        print("x is NOT present in locals() in test2().")

    if 'x' in globals():
        print("x is defined globally in test2()")
    else:
        print("x is NOT present in globals() in test().")


test2()

global x
x = 5
print("setting x globally...")
test()
test2()
