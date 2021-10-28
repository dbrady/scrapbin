#!/usr/bin/env ruby
# print_in_columns.rb - given a list of pairs

# TODO: split out the functionality. Create these methods:

# 1. format_columns returns an array of formatted strings so I can use this
#    method from other code or scripts that don't want to use the console
# 2. print_in_columns calls method format_colums and prints it to the console
# 3. a monkeypatch to put print_in_columns on the IO class so you can do
#    $stdout.print_in_columns(list) or file.print_in_columns(list)

# TODO: generalize from pairs to n-tuples, e.g. print a 3- or 4- or 15-column matrix?

# 2021-10-28 This all works just fine, but ugh. I remember I wrote csv-to-table
# and couldn't remember why it wasn't this hard. The text-table gem is why.

# list = list of items, all items must have same size
# alignment = list containing alignment for each column, :left, :right or :center
def print_in_columns(list, glue=" ", align=nil, padding: 0, fill: " ")
  column_count = list.first.size
  longest_items = []
  list.each do |tuple|
    tuple.each.with_index do |item, index|
      longest_items[index] = [longest_items[index] || 0, item.size].max
    end
  end

  alignment_method = ->(align) do
    raise ArgumentError.new("Unknown alignment '#{align}', must be one of: nil, :left, :right, :center") unless [nil, :left, :right, :center].include?(align)

    case align.to_s
    when "left", "" then :ljust
    when "right" then :rjust
    when "center" then :center
    end
  end

  alignment_methods = case align
                      when nil
                        [:ljust] * column_count
                      when Symbol, String
                        [alignment_method[align]] * column_count
                      else
                        align.map {|item| alignment_method[item] }
                      end

  # puts "Longest Items: #{longest_items.join(', ')}"
  # puts "Alignment Methods: #{alignment_methods.join(', ')}"
  # puts "Padding: #{padding}"
  # puts "Fill: #{fill}"

  pad = ->(item) { pad_text = fill * padding; "#{pad_text}#{item}#{pad_text}" }

  list.each do |tuple|
    line = glue + tuple.map.with_index { |item, index|
      pad.call(item.to_s.send(alignment_methods[index], longest_items[index], fill))
    }.join(glue) + glue
    puts line
  end

  # longest_title = list.map {|tuple| tuple.first.to_s.size }.max
  # justify_token = left_justify ? "-" : ""
  # format = "%#{justify_token}#{longest_title}s %s"
  # list.each do |tuple|
  #   puts format % pair
  # end
end

if __FILE__==$0

  # ruby -e 'require "json"; srand(42); num_lines = 5; words_per_line = 5; lines = []; words = IO.readlines("/usr/share/dict/words").map(&:strip); num_lines.times { lines << words.sample(words_per_line)}; print "ray = "; puts JSON.pretty_generate(lines)'

  ray = [
    [
      "mythopastoral",
      "pimpleback",
      "ordu",
      "laicity",
      "mothproof"
    ],
    [
      "Maine",
      "Tritonic",
      "discretionary",
      "palatinate",
      "uncreatedness"
    ],
    [
      "retaliator",
      "horologically",
      "measuring",
      "nongranular",
      "scissorbird"
    ],
    [
      "sturdyhearted",
      "autocarpian",
      "confidentialness",
      "exteriorize",
      "esoterism"
    ],
    [
      "acanthopodous",
      "eelskin",
      "sune",
      "establishmentarianism",
      "teameo"
    ]
  ]

  puts "print_in_columns(ray):"
  print_in_columns ray
  puts

  puts 'print_in_columns(ray, "|", [nil, :center, :right, :left, nil], padding:3, fill: ".")'
  print_in_columns ray, "|", [nil, :center, :right, :left, nil], padding: 3, fill: "."

end
