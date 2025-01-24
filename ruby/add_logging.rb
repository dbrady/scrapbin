require 'logger'

# MyLogger - Wrap existing methods in logging.
#
# class MyClass
#   def multiply(x, y, &block)
#     yield x
#     yield y
#     return x*y
#   end
#
#   include MyLogger
#   add_logging_to :multiply
# end
#
# MyClass.new.multiply(2,3) {|num| do_thing(num) }
#
# => in log/add_logging.log:
# > multiply(2 ,3) called
# -> multiply yielding 2
# -> multiply yielding 3
# < multiply returning 6
module MyLogger
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def add_logging_to(method_name)
      alias_method "#{method_name}_without_logging", method_name

      define_method(method_name) do |*args, &block|
        logger = Logger.new('log/add_logging.log')
        logger.info("> #{method_name}(#{args.join(', ')}) called")

        result = nil
        if block_given?
          result = send("#{method_name}_without_logging", *args) do |*block_args|
            logger.info("-> #{method_name} yielding #{block_args.join(', ')}")
            yield(*block_args)
          end
        else
          result = send("#{method_name}_without_logging", *args)
        end

        logger.info("< #{method_name} returning #{result.inspect}")
        result
      end
    end
  end
end

class Widget
  include MyLogger

  def multiply(x, y)
    x * y
  end

  def give_product(a, b)
    yield(a)
    yield(b)
    yield(a * b)
  end
end

# Add logging to the methods
Widget.add_logging_to :multiply
Widget.add_logging_to :give_product

# Example usage
widget = Widget.new
widget.multiply(3, 4)
widget.give_product(5, 6) { |num| puts "Processing #{num}" }
