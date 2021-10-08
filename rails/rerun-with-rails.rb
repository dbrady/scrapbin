#!/usr/bin/env ruby

# This is a Rails script; rerun it under rails runner if Rails isn't defined
if __FILE__==$0 && !defined?(Rails)
  cmd = "bundle exec rails runner #{__FILE__}"
  puts cmd
  system cmd
  exit $?.to_i
end
