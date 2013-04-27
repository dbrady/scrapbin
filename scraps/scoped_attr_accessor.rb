#!/usr/bin/env ruby

# This module adds scoped accessor methods to Ruby Classes. For
# example:
#
# class Foo
#   private_attr_reader :thing1, :thing2, :thing3
#   protected_attr_writer :counter
#   protected_attr_accessor :flagbag
# end
#
# They work exactly the same as the regular ruby attr_accessor
# methods, except they are placed in thea appropriate public or
# private scope as desired.
#
# Explore the code at your leisure, but if you just want to know if it
# works on your version of ruby, just run it. You'll need
# minitest/autorun installed--the tests are the bottom half of the
# file. If you are running Ruby 1.9.3 you'll need to install the
# minitest gem; if you are running Ruby 2 it's part of the Standard
# Library.
module ScopedAttrAccessor
  def private_attr_reader(*names)
    attr_reader(*names)
    names.each {|name| private name}
  end

  def private_attr_writer(*names)
    attr_writer(*names)
    names.each {|name| private "#{name}=" }
  end

  def private_attr_accessor(*names)
    attr_accessor(*names)
    names.each {|name| private name; private "#{name}=" }
  end

  def protected_attr_reader(*names)
    protected
    attr_reader(*names)
  end

  def protected_attr_writer(*names)
    protected
    attr_writer(*names)
  end

  def protected_attr_accessor(*names)
    protected
    attr_accessor(*names)
  end
end

# I'll Just Leave This Here...
# (Because I want this to act like part of the ruby language, I'm
# adding these class macros directly onto Object.)
class Object
  extend ScopedAttrAccessor
end

if __FILE__==$0
  # ----------------------------------------------------------------------
  # TEST CLASSES
  #
  # Foo uses all the goods, and also has public attr_readers mixed in
  # after the readers and then after the writers and accessors. This is
  # so the test suite can check to make sure that we stayed in public
  # scope afterwards.
  # ----------------------------------------------------------------------

  class Foo
    attr_reader :pub_read1, :pub_read2
    private_attr_reader :priv_read1, :priv_read2
    protected_attr_reader :prot_read1, :prot_read2

    attr_reader :pub_read3, :pub_read4

    private_attr_writer :priv_write1, :priv_write2
    protected_attr_writer :prot_write1, :prot_write2

    private_attr_accessor :priv_access1, :priv_access2
    protected_attr_accessor :prot_access1, :prot_access2

    attr_reader :pub_read5, :pub_read6

    private
    # this is a REALLY weird edge case, it's probably a bad idea to ever
    # do this intentionally but I want to prove that, from this private
    # scope, the prot_read3 accessor is created in protected scope AND
    # that we bounce back not to public scope, but to private
    protected_attr_reader :prot_read3

    # We'll test this for privacy down below
    attr_reader :priv_read3

    public

    def initialize
      @pub_read1 = "pub_read1"
      @pub_read2 = "pub_read2"
      @pub_read3 = "pub_read3"
      @pub_read4 = "pub_read4"
      @pub_read5 = "pub_read5"
      @pub_read6 = "pub_read6"

      @prot_read1 = "prot_read1"
      @prot_read2 = "prot_read2"
      @prot_read3 = "prot_read3"
      @prot_write1 = "prot_write1"
      @prot_write2 = "prot_write2"
      @prot_access1 = "prot_access1"
      @prot_access2 = "prot_access2"

      @priv_read1 = "priv_read1"
      @priv_read2 = "priv_read2"
      @priv_read3 = "priv_read3"
      @priv_write1 = "priv_write1"
      @priv_write2 = "priv_write2"
      @priv_access1 = "priv_access1"
      @priv_access2 = "priv_access2"
    end

    # Allow tests to peek and poke the private accessors
    def peek_at_priv_read1; priv_read1; end
    def peek_at_priv_read2; priv_read2; end
    def peek_at_priv_read3; priv_read3; end

    def peek_at_priv_write1; @priv_write1; end
    def peek_at_priv_write2; @priv_write2; end

    def peek_at_priv_access1; priv_access1; end
    def peek_at_priv_access2; priv_access2; end

    def poke_at_priv_write1(s); self.priv_write1 = s; end
    def poke_at_priv_write2(s); self.priv_write2 = s; end

    def poke_at_priv_access1(s); self.priv_access1 = s; end
    def poke_at_priv_access2(s); self.priv_access2 = s; end

    # Test only -- This method must not work!
    def peek_at_priv_read3_via_protected_access_BAD; self.priv_read3; end
  end

  class Bar < Foo
    def initialize
      super
    end

    # peek at our inherited readers
    def peek_at_prot_read1; prot_read1; end
    def peek_at_prot_read2; prot_read2; end
    def peek_at_prot_read3; prot_read3; end

    # peek at the writers
    def peek_at_prot_access1; prot_access1; end
    def peek_at_prot_access2; prot_access2; end
    def peek_at_prot_write1; @prot_write1; end
    def peek_at_prot_write2; @prot_write2; end

    def poke_at_prot_write1(s); self.prot_write1 = s; end
    def poke_at_prot_write2(s); self.prot_write2 = s; end

    def poke_at_prot_access1(s); self.prot_access1 = s; end
    def poke_at_prot_access2(s); self.prot_access2 = s; end
  end

  # ----------------------------------------------------------------------
  # TEST CODE - Exercises the example classes above
  # ----------------------------------------------------------------------

  require 'minitest/autorun'

  class TestFoo < MiniTest::Unit::TestCase
    def setup
      @foo = Foo.new
      @bar = Bar.new
    end

    # This is just a sanity check; if it fails start chewing the straps
    def test_unaltered_public_accessors_still_work_normally
      @foo.pub_read1.must_equal "pub_read1"
      @foo.pub_read2.must_equal "pub_read2"
    end

    # Happy path test 1. If priv_read1-3 are private, they should be
    # inaccessible
    def test_private_readers_are_in_fact_private
      lambda { @foo.priv_read1 }.must_raise NoMethodError
      lambda { @foo.priv_read2 }.must_raise NoMethodError
      lambda { @foo.priv_read3 }.must_raise NoMethodError
    end

    def test_private_writers_are_in_fact_private
      lambda { @foo.priv_write1 = "OH NOES" }.must_raise NoMethodError
      lambda { @foo.priv_write2 = "OH NOES" }.must_raise NoMethodError
    end

    def test_private_accessors_are_in_fact_private
      lambda { @foo.priv_access1 = "OH NOES" }.must_raise NoMethodError
      lambda { @foo.priv_access2 = "OH NOES" }.must_raise NoMethodError
    end

    # Happy path test 2. priv_read1 and priv_read2 may be inaccessible, but are they
    # in fact present? Use the public peek_at_* methods to check them
    def test_private_readers_do_in_fact_exist
      @foo.peek_at_priv_read1.must_equal "priv_read1"
      @foo.peek_at_priv_read2.must_equal "priv_read2"
      @foo.peek_at_priv_read3.must_equal "priv_read3"
    end

    def test_private_writers_do_in_fact_work_as_writers
      @foo.poke_at_priv_write1 "OOH NEAT1"
      @foo.poke_at_priv_write2 "OOH NEAT2"
      @foo.peek_at_priv_write1.must_equal "OOH NEAT1"
      @foo.peek_at_priv_write2.must_equal "OOH NEAT2"
    end

    def test_private_accessors_do_in_fact_work_as_accessors
      @foo.poke_at_priv_access1 "OOH WOW1"
      @foo.poke_at_priv_access2 "OOH WOW2"
      @foo.peek_at_priv_access1.must_equal "OOH WOW1"
      @foo.peek_at_priv_access2.must_equal "OOH WOW2"
    end

    # Happy path test 3. If prot_read1-3 are protected, they should be
    # inaccessible
    def test_protected_readers_are_in_fact_private
      lambda { @foo.prot_read1 }.must_raise NoMethodError
      lambda { @foo.prot_read2 }.must_raise NoMethodError
      lambda { @foo.prot_read3 }.must_raise NoMethodError
    end

    # Happy path test 4. prot_read1 and prot_read2 may be inaccessible, but are they
    # in fact present? Use the public peek_at_* methods to check them
    def test_protected_readers_do_in_fact_exist
      @bar.peek_at_prot_read1.must_equal "prot_read1"
      @bar.peek_at_prot_read2.must_equal "prot_read2"
      @bar.peek_at_prot_read3.must_equal "prot_read3"
    end

    # And now the million dollar question: private_attr_accessor changes
    # the scoping to private. When we come back out of this accessor, is
    # Ruby still in private scope? Or does it revert to the scope it had
    # beforehand?
    def test_public_readers_AFTER_private_accessors_still_work_normally
      @foo.pub_read3.must_equal "pub_read3"
      @foo.pub_read4.must_equal "pub_read4"
      @foo.pub_read5.must_equal "pub_read5"
      @foo.pub_read6.must_equal "pub_read6"
    end

    # And the million-and-one-dollar question: Inside the explicitly
    # private scope, after we created protected reader 3, did
    # attr_accessor priv_read3 still get created privately?
    def test_private_readers_AFTER_protected_accessors_are_STILL_private
      lambda { @foo.peek_at_priv_read3_via_protected_access_BAD }.must_raise NoMethodError
    end

    def test_protected_writers_are_in_fact_protected
      lambda { @bar.prot_write1 = "OH NOES" }.must_raise NoMethodError
      lambda { @bar.prot_write2 = "OH NOES" }.must_raise NoMethodError
    end

    def test_protected_accessors_are_in_fact_protected
      lambda { @bar.prot_access1 = "OH NOES" }.must_raise NoMethodError
      lambda { @bar.prot_access2 = "OH NOES" }.must_raise NoMethodError
    end

    def test_protected_writers_do_in_fact_work_as_writers
      @bar.poke_at_prot_write1 "AWW YEAH1"
      @bar.poke_at_prot_write2 "AWW YEAH2"
      @bar.peek_at_prot_write1.must_equal "AWW YEAH1"
      @bar.peek_at_prot_write2.must_equal "AWW YEAH2"
    end

    def test_protected_accessors_do_in_fact_work_as_accessors
      @bar.poke_at_prot_access1 "OH SNAP1"
      @bar.poke_at_prot_access2 "OH SNAP2"
      @bar.peek_at_prot_access1.must_equal "OH SNAP1"
      @bar.peek_at_prot_access2.must_equal "OH SNAP2"
    end
  end
end
