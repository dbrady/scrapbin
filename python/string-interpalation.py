#!/usr/bin/env python

count = 42

# ======================================================================
# Method One: "%s" % "Old-Style"
# ======================================================================

print("%s doesn't have an explicit sprintf method." % "Python")
print("But it does share the %s operator like %s." % ("%", "ruby")) # takes 1 arg like ruby, but must be a tuple (), not an array [].
print("This is considered the 'old style' of string formatting.")
print("While it has been 'de-emphasized', it is NOT deprecated.")
print("'it is not going away any time soon'. (Then again, 'soon' is")
print("an undefined term, and that sentence was written in 2012,")
print("which is over 10 years ago at the time of THIS writing.")


# ======================================================================
# Method Two: "{}".format("String#format()")
# ======================================================================

class Widget:
    pass

widget = Widget()
widget.size = 32

print("""
Python 3 introduced string#format(), which is doing its own thing, man.

Check out the string formatting primer here:
{url}

It can repeat things from a single input: ({hi}, {hi}, and {hi}),
can choose formats ({num}, 0x{num:x}, 0x{num:02X}, 0b{num:08b}, ${cost:5.2f}).
It supports positional arguments for the terminally lazy: {0}, {1}
It can call methods on its parameters (widget size 'w.size' is {w.size})
And even on positional args (widget size as '2.size' is also {2.size})

It's doing some other cool stuff like x!s, x!r, and x!a, which calls str(x),
repr(x), and ascii(x), respectively. (Nice if you've been handed a big chunk
of data and you want to change one element without tapping the whole chunk.)

Alignment is no longer handled with +/-n, but with >, <, =, and ^:

left:   '{hi:<10s}'
right:  '{hi:>10s}'
center: '{hi:^10s}'
=:      '{cost:=+10.2f}' (note that x.yf is still x = total width, including decimal, sign and padding)

num.to_s.reverse.each_slice(3).map(&:join).join(',').reverse

Can be implemented simply as "{{cost:,}}.format(num)": ({cost:,})


""".format(
    'first',
    'second',
    widget,
    w=widget,
    hi="Hi!",
    num=10,
    cost=12345.67,
    name='8 spaces in 16',
    url='https://docs.python.org/3/library/string.html#string-formatting'
))

# ======================================================================
# Method Three: f"{'f-strings'}"
# ======================================================================

ordinal = 'third'
print("Ironically, the 'New-Style' formatting was eclipsed in Python 3.6,")
print("which leads to the specific observation that the new-style is no")
print("longer considered now, and the geneal observation of 'If You Call")
print("something new, eventually you will be wrong, if only because of the")
print("monotonically increasing nature of time.")
print()
print("And so cometh f'' strings...")
print()
print(f"A {ordinal}  way to format strings is with  f'' strings.")
print("It works like interpolation; not much else to say.")

# ======================================================================
# Method Four: Template("String $method").substitute(method='templates')
# ======================================================================

from string import Template
template = """
Lastly we have $method.

They are very simple and do not allow inline formatting, so anything you
wish to format must be preformatted before passing it into the template.
Still, it serves as yet another way Python is tearing up the old "One
Right Way To Do It" rules in the face of overwhelming evidence indicating
"Except When That's Literally The Worst Possible Way To Do It". This is
to be lauded.
"""

print(template.substitute(method="string templates"))

