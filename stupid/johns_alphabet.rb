#!/usr/bin/env ruby
# johns_alphabet - Tool to make fun of John Marks, who likes things to be
# alphabetized, which is a good idea on its own but since it's John we're going
# to tease him.

class String
  def alphabetize
    self.split(//).sort.join('').lstrip
  end
end

class Array
  def alphabetize
    self.map {|line| line.to_s.alphabetize }.delete_if {|line| line.empty?}.sort
  end
end
