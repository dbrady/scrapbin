#!/usr/bin/env ruby
cols = []
lead = nil
line_fields = []
ARGF.each_line do |line|
  lead ||=  line.length - line.lstrip.length
  fields = line.split(/\|/).map { |f| f.strip}
  fields.pop; fields.shift
  line_fields << fields
  fields.map {|f| f.length }.each_with_index do |len, index|
    cols[index] = len if cols[index].nil? || len > cols[index]
  end
end


format = "#{' '*lead}| #{cols.map {|l| "%%-%ds" % l} * ' | '} |"

# puts format
line_fields.each do |fields|
  puts format % fields
end
