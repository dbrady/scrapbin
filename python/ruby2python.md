# From Ruby To Python
A quick sketchpad of ideas that gave me trouble.

Hello visitors from the future! If you see something on this list for which you
know an easy or elegant solution, please let me know! Most of this list in pain
points that I would like, first and foremost, to stop being painful.

I also recognize that some of these items are idiomatically favored, meaning
that the weird way of doing it is actually intentional. Sometimes you have to
trade off A to get more of B, and if I love A but Python loves B, I'll try to
embrace that. It's not just the cost of doing business in the language, it is
literally considered to be a benefit of doing business in the language.

If, on the other hand, you see this list as a "hit list" of problems with Python
and this makes you angry, I invite you to kindly go eat shit.

# How to know if a method is a builtin vs. a class method vs. an instance

I know I can do `import builtins` and noodle around and I can do `dir(object)`
  to see its methods. It just seems weird to me that I can call `len(3)` and get
  back a TypeError. Ruby's notion of "you can send a method to anything"

# map exclusively takes a single-argument function

``` python
names = ["alice", "bob", "carol", "dave"]
print(' '.join(map(str, map(len, names))))
>>> 5 3 5 4
```

If you iterate over a collection in ruby, and the items in that collection are
themselves collections, an iterator receiving a single parameter will get the
entire item as a collection, the same as python. But if your iterator takes
multiple arguments, ruby will split up the item into those variables

# map exclusively works as a foreign function (with no access to current scope)

This is one of the best/simplest ways to describe BOLS vs. non-BOLS
languages. (Python is "Block-Oriented, Lexically-Scoped", while ruby is not.)

Is there a clean way to do this in Python?

``` ruby
sizes = [4, 6, 8]
[1, 2, 3].each do |scale|
  puts sizes.map {|size| size * scale}
end
```

The gotcha here is that scale is outside the scope of the map block, but because
blocks are implicit and not lexically scoped ruby, the block can access
it. Python is a BOLS language: block-oriented, lexically-scoped.

# A lot of things have no string representation

`print(map(fn, list))` for instance, will helpfully print `<map object at
0x10b89d0a0>`, which I guess is good for lazy evaluation and maybe there's a
clean way to get the thing to evaluate without having to forcibly map it to a
string with `', '.join(str,list)`

This is actually a twofer: `', '.join([1,2,3])` crashes with a TypeError because
you can't glue integers together with join, only other strings. EVEN IF THOSE
OBJECTS HAVE A `__STR__` method


# There is no object.inspect

Seriously why is this so damn hard?

Note: Pythonistas may reply that `print(dir(object))` works and as of
3.something it returns an array of method names instead of just being a python
console command. This is a very good answer to the question "how do I do
`object.methods`", which is not the question I asked.

# Ternary operators

I understand why they were removed, but this definitely hurts me. Ruby's
approach of having `if` return the value of the block that was evaluated means
we can get rid of the cryptic `w = x ? y : z` in favor of this, which to me
looks 1000% more readable:

```
w = if x
      y
    else
      z
    end
```

# String Replacement sub, gsub, repcale

TL;dr I miss ruby's uniformity here:

``` ruby
# str -> str
"foo bar baz qux".gsub("bar", "HELLO")
# => "foo HELLO baz qux"

# re -> str
"foo bar baz qux".gsub(/b.+z/, "HELLO")
# => "foo HELLO qux"

# re -> match
"foo bar baz qux".gsub(/b(..)/, 'B\1')
# => "foo Bar Baz qux"

# re -> programmatic calculation
"foo bar baar baaar qux".gsub(/b([a-z]+)/) {|match| "b#{match.size}"}
#  => "foo b3 b4 b5 qux"
```

UPDATE: Python sends you to 2 or 3 different  wells here (String#replace,
re.sub, and ?lambdas, maybe?) but it IS doable:

``` python
# str -> str
"foo bar baz qux".replace("bar", "HELLO")

# re -> str
re.sub("b.*z", "HELLO", "foo bar baz qux")

# re -> match
re.sub("b([a-z]*)", "B\\1", "foo bar baz baaz qux")

# re -> programmatic calculation
# tl;dr use lambda x: x.group(1)
re.sub("b([a-z]+)", lambda x: f"b{len(x.group(1))}", "foo bar baz qux")

```
