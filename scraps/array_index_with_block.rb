# array_index_with_block.rb - Add block support to Array.index.
# 
# [1,2,3,2,1,2,3,2,1].index {|i| i%3==0 }
# # => 2
# 
# NOTE: Support for this was added to some versions of Ruby 1.8.7,
# then taken back out, then added back in in ruby 1.9. Attempt to
# detect it before patching.

begin
  [1,2,3].index { |i| i==2 }
rescue ArgumentError
  class Array
    alias_method :orig_index, :index
    def index(val=nil, &block)
      if block_given?
        orig_index(find(&block))
      else
        orig_index(val)
      end
    end
  end
end

