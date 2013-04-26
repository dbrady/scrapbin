#!/usr/bin/env ruby

# This is a proof of concept. Can we create a class macro
# "private_attr_reader" that has the following properties:
#
# 1. Creates attr_reader methods for the named variables
# 2. Makes these attr_reader methods private
# 3. Does NOT affect the scope of code near it (Ie does not leave the
#    class in private scope)
#
# The answer is "yes!". This file only implements private readers, but
# I'm committing it as a cleaner demonstration of the principle. For
# the full version, see "scoped_attr_accessor.rb" in this same repo.
#
# Explore the code at your leisure, but if you just want to know if it
# works on your version of ruby, just run it. You'll need
# minitest/autorun installed--the tests are the bottom half of the
# file. If you are running Ruby 1.9.3 you'll need to install the
# minitest gem; if you are running Ruby 2 it's part of the Standard
# Library.
module PrivateAttrReader
  def private_attr_reader(*names)
    private
    attr_reader *names
  end
end

# ----------------------------------------------------------------------
# EXAMPLE CLASS - Used by test code below
# ----------------------------------------------------------------------

class Foo
  # Later we'll patch this straight into Object. Because RUBY!
  extend PrivateAttrReader

  # these should be public, as one would expect.
  attr_reader :bar, :baz
  # these should be private.
  private_attr_reader :qaz, :qux
  # these should still be public.
  attr_reader :foo, :fee

  def initialize(bar, baz, qaz, qux, foo, fee)
    @bar, @baz, @qaz, @qux, @foo, @fee = bar, baz, qaz, qux, foo, fee
  end

  # Public peeker methods to let us call our private accessors from
  # the test suite
  def peek_at_qaz
    qaz
  end

  def peek_at_qux
    qux
  end
end

# ----------------------------------------------------------------------
# TEST CODE - run this ruby file and minitest/autorun will kick in
# ----------------------------------------------------------------------
require 'minitest/autorun'

class TestFoo < MiniTest::Unit::TestCase
  def setup
    @foo = Foo.new 42, 43, 13, 14, 64, 65
  end

  # This is just a sanity check; if it fails start chewing the straps
  def test_unaltered_public_readers_still_work_normally
    @foo.bar.must_equal 42
    @foo.baz.must_equal 43
  end

  # Happy path test 1. If qaz and qux are private, they should be
  # inaccessible
  def test_private_readers_are_in_fact_private
    lambda { @foo.qaz }.must_raise NoMethodError
    lambda { @foo.qux }.must_raise NoMethodError
  end

  # Happy path test 2. qaz and qux may be inaccessible, but are they
  # in fact present? Use the public peek_at_* methods to check them
  def test_private_readers_do_in_fact_exist
    @foo.peek_at_qaz.must_equal 13
    @foo.peek_at_qux.must_equal 14
  end

  # And now the million dollar question: private_attr_reader changes
  # the scoping to private. When we come back out of this reader, is
  # Ruby still in private scope? Or does it revert to the scope it had
  # beforehand? Hint: SQUEEEE!
  def test_public_readers_AFTER_private_readers_still_work_normally
    @foo.foo.must_equal 64
    @foo.fee.must_equal 65
  end
end
