#!/usr/bin/env sendto
# An attempt to create an equivalent syntax to Elixir's `|>` pipe chaining.
#
# FAILED EXPERIMENT - But results follow. IMO Ruby SHOULD NOT support
# pipeto. (It could if we monkeypatched all of the instance methods on the core
# classes to be class methods on those same classes,
# e.g. String.reverse(string). This would still do nothing to grant immutability
# to ruby or increase its concurrency; it would just make ruby feel a little bit
# like Elixir, but in the same way that using semicolons and unnecessary parens
# makes ruby feel like JavaScript: if you really want the language to feel like
# that, go program in THAT language instead. All you're really doing is speaking
# ruby with such a thick accent that the next ruby maintainer may actually need
# to speak the other language to understand your ruby.)
#
# ----------------------------------------------------------------------
#
# TL;dr no code here; this turned out to be me convincing myself that Ruby and
# Elixir differ so fundamentally that implementing a pipeto or sendto method
# just doesn't make sense.
#
# ----------------------------------------------------------------------
#
# Longer TL;dr it COULD work if you monkeypatched all of the corelib instance
# methods to be class methods. E.g. `class String; def self.reverse(str)
# str.reverse; end; end`. Then you could do something like string.sendto(String,
# :reverse).sendto(...)
#
# Interesting Takeaway: Ruby, Elixir and Smalltalk all differ in their chaining
# idioms, and this results in fundamentally incompatible* message chaining
# syntax and idioms.
#
# 1. Smalltalk's object chaining depends on messages sent to objects always
#   returning the object you sent the message to, so "name".capitalize.reverse
#   and so on works fine because you're just having an extended conversation
#   with a single object. The drawback to always returning self means you can't
#   return an object of a different class, so you can't chain your way through
#   splitting a string to an array, mapping the array through a transform, then
#   joining the array back to a string.
#
# 2. Ruby's object chaining allows for returning any object from a method, which
#   means you can easily do something like
#   `full_name.split(/\s/).map(&:capitalize).join(' ')`. However, the recipient
#   of the next message in the chain is always the object returned from the
#   previous message. Ruby lacks a robust set of global methods that take an
#   instance as the first argument (e.g. String#reverse is an instance method,
#   and there is no equivalent `String.reverse(string)`. If there were such
#   versions of these messages, creating a chaining mechanism matching Elixir
#   would be trivial, e.g. `name.go(String, :split).go(Array, :map, lambda
#   {|string| String.capitalize(string) }).go(Array, :join, ' ')`
#
# 3. Elixir's object chaining is based on global message targets. It allows for
#   the dot syntax chaining as well, but everybody has the wapors for |>, so
#   there you go.
#
# * By "fundamentally incompatible" I essentially mean "without invoking the
# Turing tarpit". Remember Jim Weirich implemented LISP and prefix notation in
# ruby; he just had to pass all his code around in arrays ("lists") and then
# write a prefix-based parser for it. It is possible to write ruby that looks
# like Smalltalk, but you gain none of the benefits of the Smalltalk VM. The
# same is true for implementing pipeto in Ruby. It can be done, but it would be
# a monstrosity with a tradeoff that's basically all downside.
#
# ----------------------------------------------------------------------
# Original commentary and experiment now follows.
# ----------------------------------------------------------------------
#
# An attempt to kitbash Elixir's "|>" operator, that will send a value to a
# method as the FIRST argument to a method that might want to accept multiple
# arguments.
#
# Matz is considering a proposed syntax for map with $1, $2, etc var syntax,
# sometime maybe around 2.7 or so. It looks like this:
#
# last_name_first_name = user.get_first_and_last_name.map { [$2, $1] }


# The problem is that Elixir's |> operator does NOT work like map. It's more
# akin to method chaining, with three key differences:

# 1. "foo".bar sends the "baz" message to the string "foo". "foo" is the
# receiver of the message. In Elixir, "foo" |> bar sends "foo" as the first
# argument to the bar method. bar is the receiver and "foo" is the argument.

# 2. "foo" |> bar identifies both the receiver AND the proc or method that
# executes on it. For example, [a,b,c] |> List.last means "List" is the receiver
# and "last" is the message. Methods are not first-class citizens in Ruby, which
# is how we ended up with tricky workarounds like Symbol#to_proc. Functions are
# first-class in Elixir, so List.last tells Elixir "look for the List module in
# the root/Kernel namespace, now look for the last() method inside that
# module. That's the method we're going to call. In Ruby this is somewhere
# between an unbound method and a Proc.

# 3. Elixir allows you to send additional arguments to the method, and these are
# sent AFTER the piped-in argument. For example, you can split "foo.bar" into
# two words in Elixir with String.split("foo.bar", "."). Because it's the first
# parameter, you can also do this with "foo.bar" |> String.split(".").

# How do to all this in Ruby? Actually not terrible, I think. Let's put a
# send_to method on Object, and have it receive the receiver


# okay, then rewrite all of these with send_to:
# [a,b].reverse # => [b,a]
# --> [a,b].send_to :reverse

# Aaaand there it is. Send to... what? How do we know to send it to Array? And
# if we did, Ruby just doesn't HAVE a lot of context-free/class-based methods
# for transformations. There is no String.split(string) class method, only the
# String#split instance method. TO MAKE THIS WORK, Ruby would need class-method
# versions of all of its instance methods. Then yeah, we could have a field day
# with e.g. [a,b].send_to "Enumerable.reverse"

# So maybe what ruby needs more than Symbol.to_proc is something like

# names.map(&:split, ".")

# Which I think has to be fixed in the interpreter. And that's where Matz'
# solution suddenly makes a lot more sense:

# names.map { $1.split(".") }

# Maybe it could be done in-code with patches at all the places that normally
# TAKE a proc, e.g.

# names.map_with(&:split, ".")

# And THAT is where Matz' solution suddenly starts to shine, or at least gleam
# dully: Every so often in Elixir we need to pipe a result into the SECOND or
# THIRD argument. You CAN do it, you just have to do crap like

# extension |> fn(name) -> String.split(name, ext)

# Which is just barfy. Elixir programmers will back up and rearchitect or
# redesign their code so they can AVOID getting stuck in this corner. In exactly
# the same way that Ruby programmers will often rearchitect or redesign their
# code to avoid the same problem with Symbol#to_proc needing multiple arguments.

# In conclusion:

# Ruby doesn't take well to |> because it lacks a robust set of stateless class
# methods in favor of a robust set of instance methods. This harks back to its
# Smalltalk heritage where the convention is for object instance methods to
# return self so you can continue chaining methods on that object.

# Elixir doesn't take well to method chaining because everything is expected to
# be stateless transformation functions that receive immutable objects and
# return modified duplicates that are themselves immutable.

# Ruby's method chaining falls down when the next receiver in the chain is not
# the instance being passed along the chain. This is smoothed over in most cases
# by having a well-defined set of class-changing chainable methods, such as
# Enumerable#join and String#split, which change the class of the returned
# object. Architecturally this falls apart when it does not make sense for the
# class to know about the new receiver class, i.e. when you need to make an
# arbitrary transformation to a string that does not belong in the String
# class. In those cases, Ruby falls back to its original, full map and send
# syntax.

# Elixir's piping falls down when the next receiver in the chain does not
# receive the output in the first argument position. This COULD be smoothed over
# by having alternate versions of the function, e.g. ext |>
# String.split_by_ext(name), but the Elixir convention is to keep the global
# function space quite small and uncluttered. So the final fallback is to either
# pipe to a fn and rearrange your arguments willy-nilly, or to just admit that
# your method does not fit into a clean stream of pipes and redesign or rewrite
# it accordingly.

#
# So... hrm. The next smooth spot to make here might be to have map/send
