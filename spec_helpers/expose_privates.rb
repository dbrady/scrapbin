# expose_privates - spec_helper to expose private and protected
# methods.
# 
# Example:
# 
# # Here's a Sammich class, with a bunch of silly methods.
# 
# class Sammich
#   private_class_method
#   protected
#     def slice_bread; end
#   private
#     def shuffle_condiments; end
#     def self.make_tupperware; end
# 
#   # remember that class methods are public by default even if they
#   # appear in a public block, so:
#   private_class_method :make_tupperware
# end
#
# # Okay, so here's how you'd test it:
#   
# describe "Sammich"
#   before(:each) do
#     expose_privates Sammich, :slice_bread, :shuffle_condiments
#     expose_class_privates :make_tupperware
#   end
#   
#   # The exposed Sammich methods can now be called publicly.
# end
# 
#
# ----------------------------------------------------------------------
# FIXME: If you call expose_privates(Foo, :bar) anywhere in the spec,
# it gets exposed globally, for ALL examples in ALL specs in this
# run--even specs run BEFORE this spec file is called. (It hooks into
# setup before the first spec is run.) Need to find out what the
# Test::Unit equivalent of before(:all) is.
# 
# The problem is that @@methods_to_* are getting set in the base class
# (TestCase), so all child classes are seeing it. Need to create some
# kind of registration hook that sets these as class variables in the
# *child* class.


module Test
  module Unit
    class TestCase
      setup :expose_hidden_methods
      teardown :conceal_hidden_methods
      
      superclass_delegating_accessor :methods_to_deprivatize
      superclass_delegating_accessor :methods_to_unprotect
      superclass_delegating_accessor :class_methods_to_deprivatize
      
      self.methods_to_deprivatize =  Hash.new {|hash,key| hash[key] = Array.new }
      self.methods_to_unprotect = Hash.new {|hash,key| hash[key] = Array.new }
      self.class_methods_to_deprivatize =  Hash.new {|hash,key| hash[key] = Array.new }
      
      
      def expose_hidden_methods
        self.methods_to_deprivatize.each_pair do |klass, methods|
          methods.each do |method|
            TestCase::publicify_method klass, method
          end
        end
        self.methods_to_unprotect.each_pair do |klass, methods|
          methods.each do |method|
            TestCase::publicify_method klass, method
          end
        end
        self.class_methods_to_deprivatize.each_pair do |klass, methods|
          methods.each do |method|
            TestCase::publicify_class_method klass, method
          end
        end
      end
      
      def conceal_hidden_methods
        self.methods_to_deprivatize.each_pair do |klass, methods|
          methods.each do |method|
            TestCase::privatify_method klass, method
          end
        end
        self.methods_to_unprotect.each_pair do |klass, methods|
          methods.each do |method|
            TestCase::protectify_method klass, method
          end
        end
        self.class_methods_to_deprivatize.each_pair do |klass, methods|
          methods.each do |method|
            TestCase::privatify_class_method klass, method
          end
        end
      end
      
      class << self
        def expose_privates(klass, *methods)
          methods.each do |method|
            if klass.private_instance_methods.include? method.to_s
              self.methods_to_deprivatize[klass] << method.to_sym
            elsif klass.protected_instance_methods.include? method.to_s
              self.methods_to_unprotect[klass] << method.to_sym
            else
              puts "WARNING: You asked me to expose #{klass.name}##{method} but I couldn't find it in either the private or protected methods!" unless self.public_instance_methods.include? method.to_s
            end
          end
        end
        
        def expose_class_privates(klass, *methods)
          methods.each do |method|
            if (klass.private_methods - klass.private_instance_methods).include? method.to_s
              self.class_methods_to_deprivatize[klass] << method.to_sym
            else
              puts "WARNING: You asked me to expose #{klass.name}.#{method}, but I couldn't find it in the singleton methods for the class: #{klass.singleton_methods.sort.grep(/build/) * ', '}"
            end
          end
        end
        
        def publicify_method(klass, method)
          klass.instance_eval do
            public method
          end
        end

        def publicify_class_method(klass, method)
          klass.instance_eval do
            public_class_method method
          end
        end

        def protectify_method(klass, method)
          klass.instance_eval do
            protected method
          end
        end

        def privatify_method(klass, method)
          klass.instance_eval do
            private method
          end
        end

        def privatify_class_method(klass, method)
          klass.instance_eval do
            private_class_method method
          end
        end
      end
    end
  end
end
