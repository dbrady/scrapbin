#!/usr/bin/env ruby
# csv_scraps.rb
require 'csv'

# Most common ways I use CSV and always have to go look them up...

canonical_data = [
  {'name' => 'Alice', 'age' => "12"},
  {'name' => 'Bob', 'age' => "13"},
  {'name' => 'Carol', 'age' => "14"},
  {'name' => 'Dave', 'age' => "15"},
]

file1 = StringIO.new <<FILE
name,age
Alice,12
Bob,13
Carol,14
Dave,15
FILE

file2 = StringIO.new <<FILE
name\tage
Alice\t12
Bob\t13
Carol\t14
Dave\t15
FILE

file3 = StringIO.new <<FILE
# This is the name, age data file
name,age
Alice,12
# Bob is dumb, lol
Bob,13
Carol,14
Dave,15
#Eddie, 16
FILE

file4 = StringIO.new <<FILE
Name,AGE
Alice,12
Bob,13
Carol,14
Dave,15
FILE

def csv_matches?(csv, data)
  csv.zip(data).all? {|csv_row, data_row|
    data_row.keys.all? {|key|
      (data_row[key] == csv_row[key]).tap {|match|
        unless match
          puts "data_row[key] == csv_row[key]... match? #{match.inspect}"
          puts "data_row[key]: #{data_row[key]}"
          puts "csv_row[key]: #{csv_row[key]}"
          puts "data_row[key].object_id: #{data_row[key].object_id}"
          puts "csv_row[key].object_id: #{csv_row[key].object_id}"
          puts "data_row[key] == csv_row[key]: #{(data_row[key] == csv_row[key]).inspect}"
        end
      }
    }
  }
end

# read a CSV file, treating first line as column headers
puts "Reading csv with headers..."
csv = CSV.parse file1, headers: true
csv.each do |row|
  puts "{'name' => #{row["name"]}, 'age' => #{row["age"]}},"
end
if csv_matches?(csv, canonical_data)
  puts "It matches canonical data"
else
  puts "*** DOES NOT MATCH ***"
end

# read a TSV file
puts "Reading tsv with headers..."
csv = CSV.parse file2, col_sep: "\t", headers: true
if csv_matches?(csv, canonical_data)
  puts "It matches canonical data"
else
  puts "*** DOES NOT MATCH ***"
end

# read a CSV with comments in it
puts "Reading a csv with comments in it..."
commented = CSV.parse file3, skip_lines: /^\s*#/, headers: true
if csv_matches?(csv, canonical_data)
  puts "It matches canonical data"
else
  puts "*** DOES NOT MATCH ***"
end

# read a CSV and downcase, symbolize the keys
puts "Reading a CSV with mixed-case headers, converting to symbols..."
keymunged = CSV.parse file4, header_converters: [:downcase, :symbolize]
if csv_matches?(csv, canonical_data)
  puts "It matches canonical data (even though canonical data has string keys)"
else
  puts "*** DOES NOT MATCH ***"
end

symbolized_canon = canonical_data.map {|row| {name: row["name"], age: row["age"] }}
if csv_matches?(csv, symbolized_canon)
  puts "It matches canonical data (after conversion to symbol keys)"
else
  puts "*** DOES NOT MATCH ***"
end

# read a CSV and convert the age column
# puts "Reading a CSV with mixed-case headers, converting to symbols..."
# keymunged = CSV.parse file4, header_converters: [:downcase, :symbolize] # , converters: ??? #{"age" => :integer}?
# if csv_matches?(csv, canonical_data)
#   puts "It matches canonical data"
# else
#   puts "*** DOES NOT MATCH ***"
# end
