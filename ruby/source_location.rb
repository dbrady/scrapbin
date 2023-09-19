#!/usr/bin/env ruby

class Foo
  def greeting
    "Hello!"
  end
end

class Bar < Foo
end

def greeting
  Foo.new.greeting
end

greeting
Foo.new.greeting
Bar.new.greeting

# Where is that method or class from?

{
  puts_location: method(:puts).source_location,
  greeting_location: method(:greeting).source_location,
  foo_greeting_location: Foo.method(:greeting).source_location,
  bar_greeting_location: Bar.method(:greeting).source_location,
  foo_location: Module.const_source_location(:Foo),
  bar_location: Foo.const_source_location(:Bar),
}.each do |what, where|
  puts "%25s is here: %s" % [what, where.inspect]
end
