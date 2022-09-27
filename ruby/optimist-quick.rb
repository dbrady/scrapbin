#!/usr/bin/env ruby
require 'optimist'

opts = Optimist.options do
  opt :flag # type is inferred from default, or boolean if nothing specified
  opt :string, "String", type: :string, default: 'value'
  opt :integer, "Integer", type: :integer, default: 42
  opt :float, "Float", type: :float, default: 69.42
end

puts sprintf("Flag: %s", opts[:flag].inspect)
puts sprintf("String: %s", opts[:string])
puts sprintf("Integer: %d", opts[:integer])
puts sprintf("Float: %5.20f", opts[:float])
