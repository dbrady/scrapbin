# CrashyDouble - base class for building test doubles whose methods
# automatically crash unless and until you implement them in the child
# class. Also lets you use allow().to_receive and expect().to_receive because
# the methods WILL be defined in the test double, and can be overridden and
# called without an ArgumentError because the methods are generated with the
# correct arity.
#
# usage:
#
# class WidgetDouble < CrashyDouble
#   mock_methods_with_0_arguments :height, :width, :created_at
#   mock_methods_with_1_arguments :height=, :width=, :[]
#   mock_methods_with_2_arguments :[]=
# end
#
# Now WidgetDobule implements all of the methods above, and all of them will
# fail if ever called. E.g. unless you say `allow(widget).to receive(:height)`,
# calling `widget.height` will fail with "WidgetDouble#height: Please stub this
# method out in your spec. Thank you."
#
# Removed from project and placed in my devel scrapbin as a good example of
# metametaprogramming. (meta-programming a DSL, if you want to be technical.)
# The careful reader will note that in the end it was easier to change my
# architecture than to try to maintain, explain, or even remember what I was
# doing in this code.
#
# ...and this isn't even a bad example. It's fairly clear that the outer 0..5
# loop creates a set of class DSL methods called mock_methods_with_#_args, and
# some careful reading inside the loop will show that we have to build the
# arglist for each method, from `do` up to `do |a,b,c,d,e|`. Then when you write
# a test double you can inherit from CrashyDouble and call
# `mock_methods_with_2_args :foo, :bar` to create foo(a,b) and bar(a,b). These
# methods then immediately raise the equivalent of a NotImplementedError.
#
# I finally decided that doing this was effectively supporting static
# interfaces, and if I were to do so I should probably be more explicit about
# it. I created modules in app/models/interfaces that defined all the methods
# and implemented them to raise NotImplementedError. I'm not normally a fan of
# defining interfaces like this in ruby but in the case that birthed this bit of
# metametaprogramming I had a collaboration pattern between models and caches
# such that a decorator would join the model and the cache together, but there
# were multiple models and multiple cache implementations, so the model and
# cache could not know anything about each other at all (not even interfaces),
# and the decorator could not know anything about the models or caches EXCEPT
# their interfaces.
#
# *** Stop here and skip to the code unless code archaeology interests you ***
#
# Journaling the refactoring history so I can review my thought process later.
#
# Context: This code came out of a code spike to separate caching behavior from
# model behavior in three different models, each of which called a (very slow)
# remote service, and each of which independently evolved its own caching
# mechanism to deal with said very-slowness. I had decided to separate the
# caches from the models, have the models access the remote services, and then
# have a decorator class wrap the model class and add caching. On paper the
# interfaces were pretty clear so I decided to push forward with top-down
# programming, implementing the decorator class BEFORE changing any of the
# models or extracting any of the caches. At the time of this writing, I have
# finished the decorator class and exhaustively specced that if the model and
# cache both support the necessary interfaces, the decorator will cleanly add
# caching support to the model. Okay, that's the context. On with the code.
#
# The reason CrashyDouble briefly came into existence is that I wrote the modules
# defining the interfaces the model had to support, but I had not yet written
# the interface to the cache--which turned out to be the largest interface of
# them all. So I had, e.g. `RemoteServiceDouble` which simply said `include
# RemoteService` but my `CacheDouble` class had no such module to include. So
# the file evolved as follows:
#
# Refactoring history:
#
# 1. First I declared methods as I discovered I needed them, e.g. get, set,
# clear, size, etc. I wanted to enforce stubbing out the methods in the other
# interfaces so I wouldn't accidentally "creep" into the implementation of other
# classes. To do this all of the methods raised a message like "CacheDouble#get:
# Please stub this method out in your spec. Thank you."
#
# 2. Eventually I realized that only the method name and the method arity
# changed, everything else was duplication. I also realized I only had methods
# of 0-arity (clear, size, created_at, etc) and 1-arity (get, set, created_at=,
# etc). So I wrote two loops in CachedDouble, one for each arity. The first
# called `define_method method_name do` and the second called `define_method
# method_name do |dummy|`.
#
# 3. I quickly realized that the loops were ALSO pure duplication except for the
# method arity, but changing them would require changing the actual hard-coded
# syntax in ruby, because 0-arity blocks cannot have `do ||` in them. At the
# time of this writing I know of no other way to do this than eval. Since I
# loathe using eval (I hate writing code inside strings, and I REALLY hate
# writing *complicated* code inside strings), I slept on it before making the
# change. In the morning I still could think of no other way, but I *DID*
# realize that as a test double base class this could be reused by all of the
# xDouble classes to create crashy methods. This seemed like a worthy tradeoff
# to me, and thus CrashyDouble was born.
#
# 4. I spent about an hour writing, debugging, and wordsmithing a second loop
# for methods with arity between 6 and 20 that would return a pithy message
# refusing to mock a method with that many parameters. After I got it just so, I
# tested it out and saw my test suite crash with that message and realized that
# I would punch any programmer who did that to me, even if it was myself, so I
# screenshotted the code for giggles and then deleted it. CrashyDouble still
# doesn't support `mock_methods_with_6_args`, but now it's also not a jerk about
# it.
#
# 5. I now had a very clean, two-line implementation of `CacheDouble`:
# `mock_methods_with_0_args (list)` and `mock_methods_with_1_args (list)`.
# (Yeah, "1 args" make me cringe but nowhere near as much as special-casing the
# metametaprogramming to allow for syntactic variations.) I went to port
# `RemoteServiceDouble` and the other test double classes to use
# `CrashyDouble`... and that's when I realized that THEY all just included their
# respective interface module. THAT'S when I realized that the only reason
# `CacheDouble` was such a mess was that I had not yet written the interface or
# any of the cache classes.
#
# 6. If you're just skimming along, this is the point that I realized that
# CrashyDouble needed to go away and all the effort I put into it was now purely
# an investment in my own knowledge and experience. Worthwhile, but still a bit
# painful.
#
# 7. To maximize this investment, and because I think the code genuinely may be
# of use someday, I am moving this code to my scrapbin and taking time to
# retrospect on this code and how it came to be (and then to not be). I took
# away three lessons from this:
#
# 7.1. This was evidence of a total win for top-down programming. Because I did
# all my work in the decorator class, I never wrote a cache class so I never
# needed the cache interface. (Well, actually I did--see lesson 3.)
#
# 7.2. This code in my scrapbin file for legacy value. Yay!
#
# 7.3. Don't pair program without a pair, kids. I'm strongly
# pair-programming-infected, and I've learned to leverage my partner. Writing
# code solo requires a different (to my mind wasteful) type of thinking, because
# one person has to manage the scope from 10,000 feet to 1 micron. I've
# practiced very hard at letting go of my need to manage both extremes of scope,
# and now I find the effort to solo code much more painful. I keenly feel the
# loss of the benefits of pairing. To wit, this is something my pair would have
# caught and stopped before it began. Instead I sunk a lot of time (I am not
# willing to publicly disclose how much) into futzing with this class and
# extracting this meta DSL. While I never needed to implement the `Cache` class,
# I did need a `CacheDouble` class, and since all of my other `xDouble` classes
# had interface modules, I clearly needed a `Cacheable` or `Caching` interface
# right from the get-go. At some point during development I extracted all of the
# interfaces used by the model but kept on pushing methods into `CacheDouble`
# directly. This kind of larger-scale, bigger-picture, situational awareness is
# something I've learned to rely on my pair for, leaving my brain free to focus
# on the minutiae of ty(p)ing tight, clean knots in the code.
class CrashyDouble
  class <<self
    (0..5).each do |num_args|
      arglist = num_args.zero? ? "" : '%s' % (('a'..'e').to_a[0...num_args] * ',')
      class_eval <<DEFINE_MOCKERY
        def mock_methods_with_#{num_args}_args *method_names
          method_names.each do |method_name|
            method_display_name = "%s#%s(%s)" % [name, method_name, "#{arglist}"]
            define_method method_name do |#{arglist}|
              raise "%s: Please stub this method out in your spec. Thank you." % method_display_name
            end
          end
        end
DEFINE_MOCKERY
    end
  end
end
