#!/usr/bin/env ruby
# coding: utf-8

# run 'filtered_iteration_test.sh' to see this get exercised
require 'debug_inspector'

def find_matchers(keys)
  matchers = []
  matcher_suffixes = ['IS', 'GT', 'GE', 'LT', 'LE', 'EQ', 'NE', 'IS_NOT', 'MATCHES', 'DOESNT_MATCH', 'IMATCHES', 'DOESNT_IMATCH']
  prefix='DESCRIBED'
  keys.any? do |key|
    matcher_suffixes.any? do |suffix|
      var = '%s_%s_%s' % [prefix, key.upcase, suffix]
      matchers << [var, ENV[var]] if ENV.key?(var)
    end
  end
  matchers
end

def should_i_yield? hash
  matchers = find_matchers(hash.keys)
  matchers.empty? || matchers.all? {|m| matches?(m, hash) }
end

def matches?(matcher, hash)
  name, value = *matcher
  matcher_ops = {
    'IS' => ['==', :to_s],
    'EQ' => ['==', :to_s],
    'GT' => ['>', :to_f],
    'GE' => ['>=', :to_f],
    'LT' => ['<', :to_f],
    'LE' => ['<=', :to_f],
    'NE' => ['!=', :to_s],
    'IS_NOT' => ['!=', :to_s],
    'MATCHES' => ['=~', :regex],
    'DOESNT_MATCH' => ['!~', :regex],
    'IMATCHES' => ['=~', :iregex],
    'IDOESNT_MATCH' => ['!~', :iregex],
  }

  matcher_ops.any? do |suffix, ray|
    if name.start_with?("DESCRIBED") && name.end_with?(suffix)
      key = name[0...-(suffix.length+1)].downcase[10..-1].to_sym
      comparator, converter = *ray
      loop_var, env_var = if converter == :regex
                            [hash[key], Regexp.new(ENV[name])]
                          elsif converter == :iregex
                            [hash[key], Regexp.new(ENV[name], Regexp::IGNORECASE)]
                          else
                            [hash[key].send(converter), ENV[name].send(converter)]
                          end
      loop_var.send(comparator, env_var)
    end
  end
end

def filtered_iteration ray, &block
  ray.each do |hash|
    next unless should_i_yield?(hash)
    yield *hash.values
  end
end

# TODO:
# [ ] Build class(es) out of this
# [ ] Refactor towards an RSpec gem
#   [ ] TWAIN - rspec-describes? rspec-groups?
#   [ ] Allow yielded describes, contexts, and its
#   [ ] "its" is already reserved so can't just pluralizes
#   [ ] Perhaps scenarios? OOOH. But don't call it rspec-scenarios because a)
#       it's probably taken and b) if it isn't people will expect it to generate
#       Cuke-style scenario charts where this is a grouped/filtered iteration
# [ ] Multiple inputs
#   [ ] Hashes
#   [ ] Arrays/CSVs with header row
#   [ ] Scenario parser
# [ ] Inject it into RSpec
# [ ] Add (required?) option for default describe string
# [ ] Test this crap
# [ ]

# ruby filtered_iteration.rb
# describe 'User Alice is 19 years old' do...end
# describe 'User Andy is 17 years old' do...end
# describe 'User Annette is 18 years old' do...end
# describe 'User Bob is 16 years old' do...end
# describe 'User Carol is 17 years old' do...end
# describe 'User Dave is 45 years old' do...end
# describe 'User Dave is 15 years old' do...end
# describe 'User Daniel is 48 years old' do...end
# describe 'User Danny is 18 years old' do...end

# DESCRIBED_NAME_IS=Dave ruby filtered_iteration.rb
# describe 'User Dave is 45 years old' do...end
# describe 'User Dave is 15 years old' do...end

# DESCRIBED_AGE_EQ=18 ruby filtered_iteration.rb
# describe 'User Annette is 18 years old' do...end
# describe 'User Danny is 18 years old' do...end

# DESCRIBED_AGE_GT=18 ruby filtered_iteration.rb
# describe 'User Alice is 19 years old' do...end
# describe 'User Dave is 45 years old' do...end
# describe 'User Daniel is 48 years old' do...end

# DESCRIBED_AGE_LE=18 ruby filtered_iteration.rb
# describe 'User Andy is 17 years old' do...end
# describe 'User Annette is 18 years old' do...end
# describe 'User Bob is 16 years old' do...end
# describe 'User Carol is 17 years old' do...end
# describe 'User Dave is 15 years old' do...end
# describe 'User Danny is 18 years old' do...end

# DESCRIBED_NAME_MATCHES=an ruby filtered_iteration.rb
# describe 'User Daniel is 48 years old' do...end
# describe 'User Danny is 18 years old' do...end

# DESCRIBED_NAME_IMATCHES=an ruby filtered_iteration.rb
# describe 'User Andy is 17 years old' do...end
# describe 'User Annette is 18 years old' do...end
# describe 'User Daniel is 48 years old' do...end
# describe 'User Danny is 18 years old' do...end

# DESCRIBED_NAME_IMATCHES='^an' ruby filtered_iteration.rb
# describe 'User Andy is 17 years old' do...end
# describe 'User Annette is 18 years old' do...end

# DESCRIBED_NAME_MATCHES='y$' ruby filtered_iteration.rb
# describe 'User Andy is 17 years old' do...end
# describe 'User Danny is 18 years old' do...end

filtered_iteration([
                        { name: 'Alice', age: 19 },
                        { name: 'Andy', age: 17 },
                        { name: 'Annette', age: 18 },
                        { name: 'Bob', age: 16 },
                        { name: 'Carol', age: 17 },
                        { name: 'Dave', age: 45 },
                        { name: 'Dave', age: 15 },
                        { name: 'Daniel', age: 48 },
                        { name: 'Danny', age: 18 },
                      ]) do |name, age|

  puts "describe 'User #{name} is #{age} years old' do...end"
end
