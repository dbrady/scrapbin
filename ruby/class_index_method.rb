#!/usr/bin/env ruby
# class index method - howtf does 'class MyMigration < ActiveRecord::Migration[6.0]' even work?

class Version1
  def whoami
    "Version 1"
  end
end

class Version2
  def whoami
    "Version 2"
  end
end

class Version
  def self.[](index)
    case index
    when 1
      Version1
    when 2
      Version2
    else
      raise ArgumentError.new("Invalid version specified")
    end
  end
end

if __FILE__==$0
  puts "Version[1].new.whoami:"
  puts Version[1].new.whoami
  puts "Version[2].new.whoami:"
  puts Version[2].new.whoami
  puts "Version[3].new.whoami:"
  puts Version[3].new.whoami
end
