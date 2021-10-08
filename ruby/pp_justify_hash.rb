#!/usr/bin/env ruby
# pp_justify_hash.rb - Pretty print a ruby hash with values tabulated.

# 2021-10-08 Dave Makes A Historical Note: Originally created in November 2018,
# this file is still "programming by wishful thinking" or "Readme-Driven
# Development".

#
# simple example:
# pp_justify_hash { foo: 42, bar: 13, arglebargle: 99 }
# =>
# {
#   foo:         42,
#   bar:         13,
#   arglebargle: 99
# }
#
# MUCH harder example:
# {
#   foo:         42,
#   bar:         13,
#   cheeses: [
#     {
#       "type"                 => "american",
#       "lbs"                  => 6.3,
#       "satisfaction_ratings" => {
#         alice: 99,
#         bob:   40,
#         carol: 66
#       },
#       "stats"                => {
#         "texture": 9.2,
#         "smell":   1
#       }
#     },
#     {
#       "type"                 => "limberger",
#       "lbs"                  => 88.4,
#       "satisfaction_ratings" => {
#         alice: 0,
#         bob:   0,
#         carol: -1000
#       },
#       "stats"                => {
#         "texture": 6.3,
#         "smell":   1000
#       }
#     }
#   ],
#   arglebargle: 99
# }
#
# Note in the above that:
#
# - arglebargle is the longest key in the root hash, so everything indents to
#   there even though there are intermediate hashes
# - symbol keys keep their colons but hashrockets are tabbed over
# - symbol keys pointing to arrays/hashes do not tabulate their open brace
# - hashrockets keys pointing to arrays/hashes DO tabulate their open brace
#
# Open Questions:

# - In some styles, I like to keep the trailing comma. This should be optional,
#   and preferably determined by the code being reformatted, but since this is
#   meant to operate on ruby data and not source code, that information is
#   lost. For now if we implement it let's pass in a flag,
#   e.g. pp_justify_hash(hash, trailing_commas: true). Then if we tie this
#   together with a source code reader THAT can try to detect trailing commas.

# - In some styles, I like to keep short structures on one line instead of
#   breaking them out, e.g. in the middle of a large justified hash I would be
#   okay with seeing something like '"data" => {a: 5, b: 9},'. There are so many
#   conflicting rules here, however, such as a) number of elements, b) string
#   length of rendered structure, c) if the rendered structure is both small and
#   short but the inline version would push the hash past 80 columns, and d) if
#   the inline version pushes past 80 columns but the per-line version ALSO
#   pushes past 80 columns. Ugh. For now let's just always do per-line. The
#   human operating this tool already knows they're in the business of
#   manipulating an insane data structure, so just let them do so.

# - HMMM. Reread that last sentence. Maybe this entire tool should not exist
#   just for that exact reason. HMM.

# - Middle of road: I *do* find myself formatting hashes often. But they're
#   usually more simple than not, and I never find myself reformatting mixed
#   symbol/string key hashes. So I would maybe be okay with a thing that JUST
#   did symbol keys, etc.
