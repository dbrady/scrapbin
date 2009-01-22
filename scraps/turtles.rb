#!/usr/bin/env ruby -w
#
# No warranty. And definitely no refunds.
#
# turtles.rb - Implement Object#andand in a turtles_all_the_way_down fashion.

module Turtles
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      alias_method :method_missing_without_turtles, :method_missing
      alias_method :method_missing, :method_missing_with_turtles      
    end
  end

  def method_missing_with_turtles(sym, *args, &block)
    if self.class.turtles?
      nil
    else
      method_missing_without_turtles(sym, *args, &block)
    end
  end

  module ClassMethods
    def turtles!
      @@enable_turtles = true
    end
    def no_turtles!
      @@enable_turtles = false
    end
    def turtles?
      @@enable_turtles ||= false
    end
    def turtles=(t)
      @@enable_turtles = t
    end
  end
end

class NilClass
  include Turtles
end

def turtles?
  NilClass.turtles?
end

def turtles!
  NilClass.turtles!
end

def no_turtles!
  NilClass.no_turtles!
end

def with_turtles
  already_turtles = turtles?
  turtles!
  begin
    x = yield
  ensure
    no_turtles! unless already_turtles
  end
  x
end

