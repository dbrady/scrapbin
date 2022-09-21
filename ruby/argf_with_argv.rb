#!/usr/bin/env ruby

def print_named_list(name, list)
  puts "#{name}:"
  list.each.with_index(1) do |arg, index|
    puts "#{index}: #{arg}"
  end
  puts
end

puts "argf_with_argv.rb, here's the breakdown:"
print_named_list "ARGV", ARGV

args_to_delete = ARGV.find_all { |arg| !File.exists?(arg) }
if args_to_delete.any?
  puts "There are some args that exist that are not files. These must be removed:"
  print_named_list "Args to Delete", args_to_delete

  ARGV.delete_if { |arg| !File.exists?(arg) }

  puts "Okay, let's look at ARGV again, then:"
  print_named_list "ARGV", ARGV
end

puts "Now then, if ARGV has any values in it, ARGF will read through them line by line in turn. If ARGV is empty, it will read from STDIN."
print_named_list "ARGF", ARGF
