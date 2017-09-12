# hash_to_table - poor man's Ruport
#
# This would be super easy to do flat; it's the recursion that's a bear
#
# flat version:
# longest_key = hash.keys.max_by(&:size)
# longest_value = hash.values.max_by(&:size)
# header = "+-#{'-' * longest_key}-+-#{'-' * longest_value }-+"
# format = "| %-{longest_key}s | %s |"
# puts header
# hash.each do |key, val|
#     puts format % [key, val]
# end
# puts header
#
# So a simple hash would be like:
# h = { color: "blue", waist_size: 42 }
# h.to_table
# =>

# +------------+------+
# | color      | blue |
# | waist_size | 42   |
# +------------+------+


# The trick will be recursion, and in fact I'm not yet sure how to do that in a
# table format to begin with. FOR NOW, just do one layer deep.
class Hash
  def to_table(formats={})
    longest_key = keys.map(&:to_s).map(&:size).max
    longest_value = values.map(&:to_s).map(&:size).max
    bar = '+-' + ('-' * longest_key) + '-+-' + ('-' * longest_value) + '-+'
    format = '+-%#{longest_key}s-+-%#{longest_value}s-+' % [longest_key, longest_value]
    puts bar
    each do |pair|
      puts format % pair
      puts bar
    end
  end
end

class Array
  def to_table(formats={})
  end
end

if $0==__FILE__
  h = {foo
