#!/usr/bin/env ruby
str = <<STRING
puts "#!/usr/bin/env ruby"
puts "str = <<STRING"
str.each_line do |line|
  puts line
end
puts "STRING"
puts
str.each_line do |line|
  puts line
end
STRING

puts "#!/usr/bin/env ruby"
puts "str = <<STRING"
str.each_line do |line|
  puts line
end
puts "STRING"
puts
str.each_line do |line|
  puts line
end
