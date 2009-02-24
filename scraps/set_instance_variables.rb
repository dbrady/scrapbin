#!/usr/bin/env ruby
# ----------------------------------------------------------------------
#  Name: set_instance_variables.rb
#  Desc: Demonstrates automagic setting of instance variables. From
#    Ruby Cookbook item 10.9, p 351.
#  Auth: dbrady
#  Date: 2007-02-02
#  Copyright (C) 2006-2007 Shiny Systems LLC
# ----------------------------------------------------------------------

class Object
  private
  def set_instance_variables(binding, *variables)
    variables.each do |var|
      instance_variable_set("@#{var}", eval(var, binding))
    end
  end
end

class SivDemo
  def initialize(x=42, y=69, z=13)
    set_instance_variables(binding, *local_variables)
  end

  def to_s
    return "<SivDemo x=#{@x}, y=#{@y}, z=#{@z}>"
  end
end

puts SivDemo.new()
puts SivDemo.new(-1)
puts SivDemo.new(-1, -2)
puts SivDemo.new(-1,-2,-3)

puts SivDemo.new(
                 SivDemo.new('x'),
                 SivDemo.new('y'),
                 SivDemo.new('z')
                 )

