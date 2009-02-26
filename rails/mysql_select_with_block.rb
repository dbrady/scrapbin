# The MIT License
#
# Copyright (c) 2008 David Brady
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.



# Patch MysqlAdapter's select_all and select_rows to accept a block
# argument. If given, the query will run and then yield each hash or
# row into the block. Note that, like select_all and select_rows, this
# returns raw SQL result row objects, not AR models.
#
# # select_rows, in a migration:
# select_rows("SELECT id, name FROM users") do |row|
#    puts "#{row[0]}: #{row[1]}"
# end
#
# # select_all, in Rails code:
# ActiveRecord::Base.connection.select_all("SELECT id, name FROM users") do |user|
#    puts "#{user['id']}: #{user['name']}"
# end
module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter      
      # Select rows and yield each row as an array into a block. Lets you work
      # large queries without caching the whole resultset beforehand.
      def select_rows_with_block(sql, name = nil, &block)
        if block_given?
          begin
            @connection.query_with_result = true
            result = execute(sql, name)
            result.each {|row| yield row }
          ensure
            result.free
          end
        else
          select_rows_without_block(sql, name)
        end
      end
      
      # Select rows and yield each row as a hash into a block. Lets you work
      # large queries without caching the whole resultset beforehand.
      def select_all_with_block(sql, name = nil, &block)
        if block_given?
          begin
            @connection.query_with_result = true
            result = execute(sql, name)
            result.each_hash {|row| yield row }
          ensure
            result.free
          end
        else
          select_all_without_block(sql, name)
        end
      end

      alias_method_chain :select_rows, :block
      alias_method_chain :select_all, :block
    end
  end
end
