#!/usr/bin/env ruby
# hash_cmp.rb - Print two hashes side by side, with differing values in red and
# matching key/values in green. Hashes are displayed in the order they appear in
# the LHS hash; the RHS has is reordered if necessary.
require 'colorize'
require 'io/console'

# TODO:
# - [ ] Move this into ~/bin repo, I'm gonna be using it a LOT more

# - [ ] Make this so much more pretty

#   - [X] Render left/right on separate lines if the left-hand side is big
#         enough to push the right-hand side out of alignment.

#   - [X] Render parent hash names with opening brace before recursing, and
#         align a closing brace after recursing. These parents are rendered in a
#         white font because this hack has to render the parent's name before
#         discovering if the child structure is different.

#   - [ ] Calculate display with and expand/contract the diff rendering to
#         accommodate.

#     - [ ] Simplest version, just calculate the screen width and build a
#           formatter off of that.

#     - [X] PUNTING. MUCH trickier version, prescan the hash and calculate
#           indent + key + value pairs all the way down, and shrink the
#           formatter columns if the entire display width is
#           unnecessary. Punting on this because the entire raisin deeter of
#           this hacktool is because I need to compare gigantic hashes that I
#           cannot visually inspect otherwise.

#   - [ ] Render parent names in the correct color to match the child hash. This
#         is actually a bit harder than it sounds. Ideally make a full app out
#         of this that separates diff calculation from diff rendering. (That
#         actually opens some doors to much better rendereing, such as
#         interactive CLI guis that let you collapse or expand nodes as you go,
#         or rendering the output in html with javascript to expand/hide nodes,
#         etc.) It could maybe be done with a simple bolt-on to the existing
#         code by having a prescan diff that returns an object mapping all of
#         the parent keys to whether or not they differ. Then the inline
#         renderer could consult this map as it goes.

# - [ ] Make this tool so much easier to use

#   - [ ] It's a PIA to have to copy and paste the RSpec diff into a file and
#         then manually edit the diff into h1 = {...}, h2 = {...}. Brainstorm
#         solutions for this. Adding a parse_diff method that takes the string
#         would be a simple step in the right direction. More difficult but
#         beautiful would be to create an rspec/pretty_hash_diff gem that plugs
#         into RSpec and just generates the diff for you. What about a version
#         that says "paste your diff now" and then stops and waits at the CLI
#         for $stdin? You could copy the diff from RSpec and just paste it in,
#         and avoid the mess of having to copy it to a file altogether.

#   - [ ] Handle WebMock RSpec diffs without a ton of cleanup. Same as above but
#         there's a lot more potential logic here. WebMock provides the illegal
#         request in one format, then emits a stub_request example in another
#         format, then lists all the existing request stubs in the second
#         format. Start by making it easier to paste in the example stub and the
#         stub that should have matched. Later, if I want to get fancy, and a
#         WebMock stub finder that would let me just paste in the entire WebMock
#         error including the entire list of stubs, and it would parse the
#         example stub and figure out which list of stubs SHOULD have
#         matched. This might be a fool's errand in the case of stubs that have
#         multiple responses to the same request, but in that event I guess the
#         operator could still fall back to identifying the correct stub by eye.

#   - [ ] Consider monkeypatching Hash with a method like #pretty_diff or
#         similar?

#   - [ ] Make the tool easy to use from an irb session, since debugging two
#         massive hashes during development means shaping the second hash to
#         match the first iteratively. In that case it might be nice to
#         continually adjust h2 without having to re-edit the program and such.

# - [X] FIXED: Missing RHS keys are skipped. To catch them, I combine the keys
#       of both hashes and uniquify them. This still preserves the order of the
#       left-hand hash but missing RHS keys are simply added at the end, not in
#       their correct position in the RHS hash. This is okay since this hack was
#       originally designed to help make sense of hashes that are completely out
#       of order with each other. The RHS hash gets reordered to match the LHS
#       anyway.

# - [X] Handle arrays - YAGNI so far. Arrays, even large ones, have been coming
#       through just fine. They get compared for equality AND order, and so far
#       all the test data I've run through this just happens to have not had a
#       major problem with the arrays. If that changes, update this
#       tool. Remember that Array#fetch(index) works exactly like
#       Hash#fetch(key) so the hardest part of making this change honestly would
#       be updating the renderer to render indexes and maybe to change the
#       pretty-print `parent => {...}` stuff to read `parent => [...]` and so
#       on.

# - [X] Handle JSON? - YAGNI. Currently we've only even had monstrous hashes to
#       deal with. If that changes we'll first attempt to deal with it by
#       parsing them before feeding them to this tool. If I spend a LOT of time
#       doing hash_cmp(JSON.parse(json1), JSON.parse(json2)), then we can talk.



# ----------------------------------------------------------------------
# Usage:
#
# load File.expand_path("~/bin/hash_cmp.rb")
#
# hash1 = { "a" => { "b" => 64, "c" => 13 }
# hash2 = { "a" => { "b" => 63, "c" => 13 }
#
# hash_cmp hash1, hash2
#
# load <this_file>
# hash_cmp hash1, hash2
# ----------------------------------------------------------------------

def hash_cmp(h1, h2, tabs=0)
  indent = "  " * tabs
  (h1.keys + h2.keys).uniq.each do |key|
    v1, v2 = h1[key], h2[key]
    if v1.is_a?(Hash)
      msg = "%s%20s => %-40s %20s => %-40s" % [indent, key, "{", key, "{"]
      puts msg
      hash_cmp(v1, v2, tabs+1)
      msg = "%s%20s    %-40s %20s    %-40s" % [indent, "", "}", "", "}"]
      puts msg
    else
      if key.to_s.size <= 20 && v1.to_s.size <= 40
        msg = "%s%20s => %-40s %20s => %-40s" % [indent, key, v1, key, v2]
      else
        msg = "%s%20s => %-40s\n%s%20s    %40s %20s => %-40s" % [indent, key, v1, indent, "", "", key, v2]
      end
      color = if v1 == v2
                :green
              else
                :red
              end
      puts msg.send(color)
    end
  end
end
