#!/usr/bin/env ruby
puts DATA.tap(&:rewind).read
__END__
DATA.rewind doesn't go back to the __END__ directive; instead it
rewinds all the way to the beginning of the file. This makes for a
very simple, if perhaps unintentional, quine.

