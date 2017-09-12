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
