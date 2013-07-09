module Enumerable
  def hash_by(id=nil, &block)
    zuul = Hash.new {|h,k| h[k] = [] }
    keymaster = id ? lambda {|x| x[id] } : lambda {|x| yield x }
    self.each do |item|
      zuul[keymaster[item]] << item
    end
    # there is no hash, there is only
    zuul
  end
end

require 'minitest/unit'
require 'minitest/autorun'

class TestHashBy < MiniTest::Unit::TestCase
  def test_block_version
    # test block version
    (1..10).to_a.hash_by {|x| x % 3 }.must_equal( {0=>[3,6,9], 1=>[1,4,7,10], 2=>[2,5,8]} )
  end

  def rogues
    [
     { name: 'Avdi', location: 'PA' },
     { name: 'Chuck', location: 'UT' },
     { name: 'Dave', location: 'UT', extra: 'weirdo' },
     { name: 'James', location: 'OK' },
     { name: 'Josh', location: 'CA' },
     { name: 'Katrina', location: 'CO' }
     ]
  end

  def test_id_version
    rogues.hash_by(:location).keys.must_equal ['PA','UT','OK','CA','CO']
    rogues.hash_by(:location)['CA'].must_equal [{name: 'Josh', location: 'CA'}]
  end

  def test_symbol_to_proc_version
    rogues.hash_by(&:size)[3].must_equal [{name: 'Dave', location: 'UT', extra: 'weirdo' }]
  end
end
