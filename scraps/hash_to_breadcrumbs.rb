# hash_to_breadcrumbs
#
# hash_to_breadcrumb - turn a hash containing items, arrays, or nested hashes
# into a flattened list of "breadcrumbs" -- e.g. the path through the hash to
# get to the last value in the list.

hash = {
  a: 1,
  b: [2, 3, 4],
  c: {
    d: 5,
    e: [6,7,8],
    f: {
      g: 9,
      h: [10, 11],
      i: {
        j: 12
      }
    }
  },
  k: [
    {l: 13},
    {m: 14}
  ]
}

expected_breadcrumbs = [
  [:a, 1],
  [:b, 2],
  [:b, 3],
  [:b, 4],
  [:c, :d, 5],
  [:c, :e, 6],
  [:c, :e, 7],
  [:c, :e, 8],
  [:c, :f, :g, 9],
  [:c, :f, :h, 10],
  [:c, :f, :h, 11],
  [:c, :f, :i, :j, 12],
  [:k, :l, 13],
  [:k, :m, 14],
]

expected_injectables = [
  [],
  [:c],
  [:c, :f],
  [:c, :f, :i],
  [:k, 0],
  [:k, 1]
]

def hash_to_breadcrumbs(object, parent=[])
  ray = []
  if object.is_a? Hash
    object.each do |key, val|
      ray += hash_to_breadcrumbs val, parent.dup + [key]
    end
  elsif object.is_a? Array
    object.each do |elem|
      ray += hash_to_breadcrumbs elem, parent
    end
  else
    ray << parent.dup + [object]
  end
  ray
end

def hash_to_injectables(object, parent=[])
  ray = []
  children = []
  if object.is_a? Hash
    ray << parent.dup
    object.each do |key, val|
      children += hash_to_injectables(val, parent.dup + [key])
    end
  elsif object.is_a? Array
    object.each.with_index do |val, index|
      children += hash_to_injectables(val, parent.dup + [index])
    end
    children = children.compact
  end
  ray += children if children.size > 0
  ray
end

puts '-' * 80
puts "Expected:"
puts '-' * 10
# puts expected_breadcrumbs.map(&:inspect)
puts expected_injectables.map(&:inspect)

# actual_breadcrumbs = hash_to_breadcrumbs(hash)
actual_injectables = hash_to_injectables(hash)
puts '-' * 80
puts "Actual:"
puts '-' * 10
puts actual_injectables.map(&:inspect)
puts '-' * 80

puts "Are they equal?"
puts(if actual_injectables == expected_injectables
     "YES YES YES OH WOOT YES YES YESSSSS!!!! WOOOOO!!!!"
    else
      "Nope."
     end)
