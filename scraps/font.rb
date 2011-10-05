block_font = <<FONT1
###| # |###|###|# #|###|###|###|###|###|   |   |
# #| # |  #|  #|# #|#  |#  |  #|# #|# #|   | # |
# #| # |###| ##|###|###|###|  #|###|###|   |   |
# #| # |#  |  #|  #|  #|# #|  #|# #|  #|   | # |
###| # |###|###|  #|###|###|  #|###|  #| # |   |
FONT1

font2 = <<FONT2
 # | # |## |## |# #|###| ##|###| # | # |   |   |
# #| # |  #|  #|# #|#  |#  |  #|# #|# #|   | # |
# #| # | # |## | ##|## |## | # | # | ##|   |   |
# #| # |#  |  #|  #|  #|# #| # |# #|  #|   | # |
 # | # |###|## |  #|## | # | # | # |  #| # |   |
FONT2

def encode_line(line)
  bin_str = '%036b' % line.gsub(/\|/, '').gsub(/#/, '1').gsub(/ /, '0').to_i(2)
  bin_str.to_i(2).to_s(16)
end

def decode_line(line, xstretch=1, ystretch=1)
  decode = []
  on_bit = '#' * xstretch
  off_bit = ' ' * xstretch
  pattern = Regexp.new("(?<f>#{'...' * xstretch})")
  bin_str = '%036b' % line.to_i(16)
  ystretch.times {
  decode << bin_str.gsub(/0/, ' '*xstretch).gsub(/1/, '#'*xstretch).gsub(pattern, '\k<f>|')
  }
  decode
end

# font2.each_line do |line|
#   bin_str = '%036b' % line.gsub(/\|/, '').gsub(/#/, '1').gsub(/ /, '0').to_i(2)
#   puts bin_str.to_i(2).to_s(16)
# end

# block font
block_font_encoded = <<STR
ebfbfffc0
a89b21b42
abbff9fc0
aa1269a42
ebf3f9e50
STR

# rounded font
round_font_encoded = <<STR
4b6bdf480
a89b21b42
a967b24c0
aa126aa42
4be392450
STR

block_font_encoded.each_line do |line|
  # 2.times { puts line.to_i(16).to_s(2).gsub(/(?<f>...)/, '\k<f> ').gsub(/0/, '   ').gsub(/1/, '###') }
  puts decode_line(line,3,2)
end

