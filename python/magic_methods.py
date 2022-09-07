#!/usr/bin/env python

# magic methods - all those funky double-underbar / double_underscore functions.
# like __init__ and __call__



class MagicClass:
    # def __new__():
    #     Called by __init__; Similar deep magic to Ruby's new method. Need to research this to see how it works.
    def __init__(self):
        print("__init__() called. This is the constructor.")
        pass

    def __call__(self, *args, **kwargs):
        print("__call__() called. This method lets an instance act like a function.")


# Research these:
# __str__ - I believe this returns a string containing a human-readable
# representation of the object, e.g. "Dobson, Bob (Age 42)"

# __repr__ - While this returns a string containing a machine-readable
# representation. (If you saved this string you could use it to reconstruct an
# equivalent object. Think of it as the write-half of "poor-man's
# marshaling"... from a day and age before we really understood that marshaling
# was not something to be left to the poor.) I think it still ends up being a
# human thing since the most common use here is to emit a string containing
# source code of a constructor for this object. I.e. "User('Bob', 'Dobson', age:
# 42)"

# __radd__ isn't in here either, wtf.



# Binary Operators:
#    +     object.__add__(self, other)  # handles the simple case of x + 2
#    +     object.__radd__(self, other) # handles the trickier case of 2 + x
#    -     object.__sub__(self, other)
#    *     object.__mul__(self, other)
#    //    object.__floordiv__(self, other)
#    /     object.__truediv__(self, other)
#    %     object.__mod__(self, other)
#    **    object.__pow__(self, other[, modulo])
#    <<    object.__lshift__(self, other)
#    >>    object.__rshift__(self, other)
#    &     object.__and__(self, other)
#    ^     object.__xor__(self, other)
#    |     object.__or__(self, other)

# Extended Assignment (e.g. *= and +=)
#    +=     object.__iadd__(self, other)
#    -=     object.__isub__(self, other)
#    *=     object.__imul__(self, other)
#    /=     object.__idiv__(self, other)
#    //=    object.__ifloordiv__(self, other)
#    %=     object.__imod__(self, other)
#    **=    object.__ipow__(self, other[, modulo])
#    <<=    object.__ilshift__(self, other)
#    >>=    object.__irshift__(self, other)
#    &=     object.__iand__(self, other)
#    ^=     object.__ixor__(self, other)
#    |=     object.__ior__(self, other)

# Unary Operators (which includes casting and, for some reason, abs()), e.g. -x, ~x, complex(x)
#    -            object.__neg__(self)
#    +            object.__pos__(self)
#    abs()        object.__abs__(self)
#    ~            object.__invert__(self)
#    complex()    object.__complex__(self)
#    int()        object.__int__(self)
#    long()       object.__long__(self)
#    float()      object.__float__(self)
#    oct()        object.__oct__(self)
#    hex()        object.__hex__(self

# Comparison Operators
#     <     object.__lt__(self, other)
#     <=    object.__le__(self, other)
#     ==    object.__eq__(self, other)
#     !=    object.__ne__(self, other)
#     >=    object.__ge__(self, other)
#     >     object.__gt__(self, other)


if __name__ == "__main__":
    magic = MagicClass()
    magic()
