#!/usr/bin/env ruby
require "erb" # for stdlib examples below
require "text-table"

class Foo
  def initialize
  end

  def greeting
    "Hello!"
  end
end

class Bar < Foo
  private
  class PrivateClassBazInsideBar
  end
end

def greeting
  Foo.new.greeting
end

greeting
Foo.new.greeting
Bar.new.greeting

table = Text::Table.new
table.head = ["Things That Work", "Where"]


# The Cans
table.rows << ["method(:greeting).source_location", method(:greeting).source_location.inspect]
table.rows << ["ERB.method(:version).source_location", ERB.method(:version).source_location.inspect]
table.rows << ["Foo.method(:greeting).source_location", Foo.method(:greeting).source_location.inspect]
table.rows << ["Bar.method(:greeting).source_location", Bar.method(:greeting).source_location.inspect]
table.rows << ["Module.const_source_location(:Foo)", Module.const_source_location(:Foo).inspect]
table.rows << ["Foo.const_source_location(:Bar)", Foo.const_source_location(:Bar).inspect]
table.rows << ["Module.const_source_location(:ERB)", Module.const_source_location(:ERB).inspect]
table.rows << ["ERB.const_source_location(:ERB)", ERB.const_source_location(:ERB).inspect]
table.rows << ["ERB.const_source_location(:Bar)", ERB.const_source_location(:Bar).inspect]
table.rows << ["Bar.const_source_location(:PrivateClassBazInsideBar)", Bar.const_source_location(:PrivateClassBazInsideBar).inspect]
puts table
puts "Note that last -- there is no scoping of public classes. Module.const_source_location reads all classes, so every class can see every class: children, ancestors, itself, unrelated, do not matter."
puts "It may be cheaply doable to just always say either Module.const_source_location(:X) or X.const_source_location(:X)"

# The Can'ts
table = Text::Table.new
table.head = ["Things That Don't", "Where", "Notes"]
table.rows << ["method(:puts).source_location", method(:puts).source_location.inspect,           "source location can't find compiled core methods"]
table.rows << ["Foo.method(:new).source_location", Foo.method(:new).source_location.inspect,        "source_location can't find :new"]
table.rows << ["Foo.method(:initialize).source_location", Foo.method(:initialize).source_location.inspect, "source_location can't find :initialize"]
table.rows << ["Kernel.const_source_location(:Object)", Kernel.const_source_location(:Object).inspect, "core module"]
table.rows << ["const_source_location(:Object)", "NoMethodError", "Must call explicitly on a Module"]
table.rows << ["Foo.const_source_location(:PrivateClassBazInsideBar)", Foo.const_source_location(:PrivateClassBazInsideBar).inspect, "Scoping IS respected if a class is private, or at least if the symbol can't be resolved locally"]
puts table
