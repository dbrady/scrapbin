#!/usr/bin/env ruby
# print_in_columns.rb - given a list of pairs

# TODO: split out the functionality. Create these methods:

# 1. format_columns returns an array of formatted strings so I can use this
#    method from other code or scripts that don't want to use the console
# 2. print_in_columns calls method format_colums and prints it to the console
# 3. a monkeypatch to put print_in_columns on the IO class so you can do
#    $stdout.print_in_columns(list) or file.print_in_columns(list)

# TODO: generalize from pairs to n-tuples, e.g. print a 3- or 4- or 15-column matrix?
def print_in_columns(list, left_justify: true)
  longest_title = list.map {|tuple| tuple.first.to_s.size }.max
  justify_token = left_justify ? "-" : ""
  format = "%#{justify_token}#{longest_title}s %s"
  list.each do |pair|
    puts format % pair
  end
end

if __FILE__==$0
  ray = [
    ["house", 7],
    ["dog", 2],
    ["cats", 9],
    ["assorted sundries", 22],
    ["pants", 42]
  ]

  print_in_columns ray

end
