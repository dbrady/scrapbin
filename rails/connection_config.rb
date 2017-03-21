# run me with Rails runner!
#
# Can't remember how to find the connection configuration? Turns out it's now in
# an obvious place (that I can never remember, so I'm writing it down here in a
# place where stand a good chance to stumble across it again)
#
# Taken from Stack Overflow:
# http://stackoverflow.com/questions/8673193/rails-activerecord-get-current-connection-specification

require 'pp'
pp ActiveRecord::Base.connection_config
