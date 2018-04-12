# Doing RSpec on a model or lib class in a Rails app and don't want to load
# Rails just to run specs for this model, which you have carefully isolated from
# all the other crap in your app? Jam this in at the head:
#
# TODO: Consider moving this into ~/bin as make-new-rspec-model <name>, put the
# code sample in __DATA__ and #{...} it into the output file for that class name
if defined? Rails
  # Rails is already defined, let's just use that
  require 'rails_helper'
else
  # Oooh, no Rails? Let's do this FAST!
  require 'spec_helper'
  require_relative '../../app/models/your_class_here'
end
