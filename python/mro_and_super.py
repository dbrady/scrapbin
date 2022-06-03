#!/usr/bin/env python
# mro_and_super.py - Exploration of super() and the Method Resolution Order


# MRO, or Method Resolution Order, dictates that we find the FIRST
# class in the ancestor tree, searching depth-first and left-to-right.
#
# So if we have:
#
# B    C
#  \  / \
#    A   D
#     \ /
#      E
#

# In E, calling super().foo() is the same as calling super(E,
# self).foo(), and will search for the foo method in A, B, C, D, and
# object, in that order.

# If no superclass provides the method, Python will raise
#
# AttributeError: 'super' object has no attribute '<method_name>'
#
# Which is consistent with how Python says "NoMethodError". Python
# wants you to keep a weather eye on the fact that it implements
# vector tables as attributes containing function pointers.

# "One advantage to super() is that you don't have to hardcode the
# parent class name, which means if you change the parent class in the
# class declaration you do not have to edit the source code of the
# class." (This is literally how super has worked in every other
# language since 1980, but ok...) Hang on, next they say: "Since the
# indirection is computed at runtime, we have the freedom to influence
# the calculation so that the indirection will point to some other
# class." Now THIS is interesting to me. Can we _modify_ the
# inheritance of a class outside of its code? If so, color this
# rubyist interested.

# WEIRDAGE #47: If you inherit from an internal class like dict, it
# gets punted to the end of the MRO! In the above example, if B was
# "dict", the MRO for E would be A, C, D, B, object. dafuq?


class Textile:
    """An item made of fabric."""
    def __init__(self):
        pass

class Clothes(Textile):
    """An article of clothing."""
    def __init__(self, name, color):
        self.name = name
        self.color = color
        print(f'Clothes is initializing with name="{self.name}" and color="{self.color}"')

    def yawp(self):
        print(f"Clothes#yawp(): I am a {self.color} {self.name}")

class Thing:
    """A pedantic end-run around the rule of 'do not have a class named Object'"""
    def __init__(self):
        pass

class Item(Thing):
    """An object that can be owned or manipulated."""
    def __init__(self, name, price):
        self.name = name
        self.price = price
        print(f'Item is initializing with name="{self.name}" and price=${self.price:.02f}')

    def yawp(self):
        print(f"Item#yawp(): I am a {self.name} worth ${self.price:.02f}")

class Hat(Clothes, Item):
    def __init__(self, name, color, price):
        self.name = name
        self.color = color
        self.price = price

        super().__init__(name, color) # MRO sez: I will call Clothes((name, color)
        print(f"Hat is initializing with name='{self.name}', color='{self.color}' and price=${self.price:.02f}")

    def yawp(self):
        super(Hat, self).yawp() # MRO will direct this to Clothes#yawp and NOT Item#yawp
        # Python 2.x old-style classes {let,make} us specify the parent explicitly
        Clothes.yawp(self)
        Item.yawp(self)
        print(f"Hat#yawp(): I am a {self.color} {self.name} worth ${self.price:.02f}")

    def bark(self):
        print("Hat#bark() called.")
        super().yawp()
        Item.bark(self)


# HMM! For diamond inheritance the common parent might appear at the
# _latest_ possible point. Meaning any child that says "wait, I am in
# front of this grandparent" will effectively push that grandparent
# further down the MRO stack. Let's check this out.
#      B
#    /   \
# A | C D | E
#  \|/   \|/
#   F     G
#    \   /
#      H
#
# If this is true, thne the MRO of H should be H F A C G D B E. F813U.
#
# Buuuut it isn't. It's  H F A G D B C E object.
#
# Ohhhh, wow. I can kind of see it. Classes declared later in the
# chain appear as late in the chain as necessary, but cannot precede a
# class that is ahead of it in the chain somewhere else? So H:F:B
# can't be checked until AFTER we've gone through H:G:B, and G:B must
# be preceded by G:D so we see H, F, A, then G, then D, and NOW we can
# finally hit B, and once we're through that we can resume iterating
# through A's parents to H:F:C, and if we still haven't found the
# method we're looking for we check H:F:E.

# Okay, that means that this hierarchy will either break Python or
# behave weirdly:
#
# N     O
# | \ / |
# | / \ |
# P     Q
#   \ /
#    R
#
# BOOM. Yep. The code doesn't even compile, even if R is never
# instantiated. Trying to compile the above hierarchy gives this
# error:
#
# Traceback (most recent call last):
#   File "/Users/david.brady/devel/scrapbin/python/mro_and_super.py", line 167, in <module>
#     class R(P, Q):
# TypeError: Cannot create a consistent method resolution
# order (MRO) for bases N, O
#

# Okay. Python's import statement works like ruby's module
# include/extend, where newer imports overwrite older ones. If you say
# from A import C; from B import C; it will work and you can call C(),
# you will get the C from B.

# Python's multiple inheritance is... doing it's own thing, man. class
# A(B, C) tells the MRO "A is in front of B and C". So in my A-H
# chart,
#
#      B
#    /   \
# A | C D | E
#  \|/   \|/
#   F     G
#    \   /
#      H
#
# We tell the resolver:
# H is in front of F
# H is in front of G
# F is in front of A
# F is in front of B
# F is in front of C
# G is in front of D
# G is in front of B
# G is in front of E
#



class A:
    pass

class B:
    pass

class C:
    pass

class D:
    pass

class E:
    pass

class F(A, B, C):
    pass

class G(D, B, E):
    pass

class H(F, G):
    pass

# Notes for https://rhettinger.wordpress.com/2011/05/26/super-considered-super/
class LoggingDict(dict):
    def __setitem__(self, key, value):
        print('Setting %r to %r' % (key, value))
        super().__setitem__(key, value)


import collections

class LoggingOD(LoggingDict, collections.OrderedDict):
    pass

if __name__ == '__main__':
    # hat = Hat('fedora', 'brown', 42.00)
    # hat.yawp()
    # print('----------------------------------------')
    print(Hat.__mro__)

    print('--')

    klass = LoggingOD
    d = klass()
    d["size"] = 42

    print(repr(d))
    print(klass.__mro__)

    print('----------------------------------------')
    print(H.__mro__)
