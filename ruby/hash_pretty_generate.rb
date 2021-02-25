# hash_pretty_generate - Display a hash all pretty-like.
# Cooperates and works with Array.pretty_generate as well.

# Usage:
# Hash.prety_generate(hash, options) : string

# Works like JSON.pretty_generate(hash), so it takes a hash and returns a string.

# Keys are aligned:
# h = {alice: 42, bob: 13, carol: 29}
# puts Hash.pretty_generate(hash)
# {
#   alice: 42,
#   bob:   13,
#   carol: 29
# }

# Subhashes are further indented, and indentation can be overridden:
# h = {alice: 42, bob: 13, carol: 29, dave: { its: 9, complicated: true }}
# puts Hash.pretty_generate(hash, indentation: "    ")
# {
#     alice: 42,
#     bob:   13,
#     carol: 29,
#     dave: {
#         its:         9,
#         complicated: true
#     }
# }

# Empty hashes and arrays show inline
# h = {alice: 42, bob: 13, carol: 29, dave: {}, eddie: []}
# puts Hash.pretty_generate(hash)
# {
#   alice: 42,
#   bob:   13,
#   carol: 29,
#   dave:  {},
#   eddie: []
# }

# Hashes with mixed keys are displayed entirely with hash rocket notation.
# h = {alice: 42, "bob" => 13, "carol" => [1, 2, 3]}
# puts Hash.pretty_generate(hash)
# =>
# {
#   :alice  => 42,
#   "bob"   => 13,
#   "carol" => [
#     1,
#     2,
#     3
#   ]
# }

class Hash
  class PrettyPrint
    def self.pretty_print(data, indent="")
      longest_key = data.keys.map(&:size).max
      format = "#{indent}%#{longest_key}s: %s"
      puts indent + "{"
      data.each_pair do |key, value|
        # temp hacks for now, need cleaner/longer/better way...
        if value.is_a? Array
          puts format % [key, value.inspect]
        elsif value.is_a? Hash
          print format % [key, ""]
          pretty_print value, indent + "  "
        else
          puts format % [key, value]
        end
      end
      puts indent + "}"
    end
  end
end

if __FILE__==$0
  h = {
    pigtruck: "sandwich",
    pants: true,
    dwarves: %w(Grumpy Dopey Doc Happy Bashful Sneezy Sleepy),
    address: {
      street: "123 Fake St",
      city: "Testville",
      state: "AS",
      zip_code: 96799
    },
    cheeses: 7
  }

  Hash::PrettyPrint.pretty_print h

end
