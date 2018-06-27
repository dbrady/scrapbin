#!/usr/bin/env ruby
# coding: utf-8

# OptionParser Reference - An attempt to demonstrate every feature

# For more information, see docco at
# * https://docs.ruby-lang.org/en/2.1.0/OptionParser.html
# * https://ruby-doc.org/stdlib-2.5.0/libdoc/optparse/rdoc/OptionParser.html
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class OptparseExample

  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

  Environment = Class.new(Object)
  ENVIRONMENTS = {
    "i" => "integration",
    "p" => "production",
    "d" => "development",
    "t" => "test",
    "tt" => "testing"
  }

  def self.find_environment(env)
    raise "Environment '#{env}' not recognized" unless ENVIRONMENTS.to_a.flatten.include?(env)
    ENVIRONMENTS.fetch(env, env) # if it's not present as a key, it's a value
  end

  def self.environments
    ENVIRONMENTS.to_a.flatten.sort.join(',')
  end

  #
  # Return a structure describing the options.
  #
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.library = []
    options.inplace = false
    options.encoding = "utf8"
    options.transfer_type = :auto
    options.verbose = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # Mandatory argument.
      # Make an argument required by putting the name of the argument in caps in
      # either or both of the short/long option specification strings
      # NOTE: The option itself is optional; this just means that if it is
      # present it must have an argument. Otherwise a
      # OptionParser::MissingArgument exception will be raised.
      opts.on("-rLIBRARY", "--require LIBRARY", # could omit one of the "LIBRARY"
              "Require the LIBRARY before executing your script") do |lib|
        options.library << lib
      end

      # Optional argument; multi-line description.
      # Make an argument optional by naming it in all caps surrounded by square
      # braces. Again note that it's only necessary in one of the
      # specifications; could also have said "-i[EXTENSION]" for the short
      # argument.
      # Additional strings are treated as a multiline description, when running
      # --help they will NOT be joined together but instead displayed each on
      # their own line and indented to match. Note the authors here have
      # included two additional spaces here; this is a style choice that
      # OptionParser permits but does not enforce.
      opts.on("-i", "--inplace [EXTENSION]",
              "Edit ARGV files in place",
              "  (make backup if EXTENSION supplied)") do |ext|
        options.inplace = true
        options.extension = ext || ''
        options.extension.sub!(/\A\.?(?=.)/, ".")  # Ensure extension begins with dot.
      end

      # Cast 'delay' argument to a Float.
      # You can make OptionParser coerce any option into any type. Types supported
      # out of the box include:
      #
      # * Date – Anything accepted by Date.parse
      # * DateTime – Anything accepted by DateTime.parse
      # * Time – Anything accepted by Time.httpdate or Time.parse
      # * URI – Anything accepted by URI.parse
      # * Shellwords – Anything accepted by Shellwords.shellwords
      # * String – Any non-empty string
      # * Integer – Any integer. Will convert octal. (e.g. 124, -3, 040)
      # * Float – Any float. (e.g. 10, 3.14, -100E+13)
      # * Numeric – Any integer, float, or rational (1, 3.4, 1/3)
      # * DecimalInteger – Like Integer, but no octal format.
      # * OctalInteger – Like Integer, but no decimal format.
      # * DecimalNumeric – Decimal integer or float.
      # * TrueClass – Accepts '+, yes, true, -, no, false' and defaults as true
      # * FalseClass – Same as TrueClass, but defaults to false
      # * Array – Strings separated by ',' (e.g. 1,2,3)
      # * Regexp – Regular expressions. Also includes options.
      opts.on("--delay N", Float, "Delay N seconds before executing") do |n|
        options.delay = n
      end

      # Make up our own type -- need a unique class name to key off of
      opts.accept(Environment) do |env|
        find_environment env
      end
      opts.on("-e", "--env=ENVIRONMENT", Environment, "Environment to run in",
              "  (Must be one of #{environments})") do |env|
        options.environment = find_environment env
      end

      # Cast 'time' argument to a Time object.
      opts.on("-t", "--time [TIME]", Time, "Begin execution at given time") do |time|
        options.time = time
      end

      # Cast to octal integer.
      opts.on("-F", "--irs [OCTAL]", OptionParser::OctalInteger,
              "Specify record separator (default \\0)") do |rs|
        options.record_separator = rs
      end

      # List of arguments.
      opts.on("--list x,y,z", Array, "Example 'list' of arguments") do |list|
        options.list = list
      end

      # Keyword completion.  We are specifying a specific set of arguments (CODES
      # and CODE_ALIASES - notice the latter is a Hash), and the user may provide
      # the shortest unambiguous text.
      code_list = (CODE_ALIASES.keys + CODES).join(',')
      opts.on("--code CODE", CODES, CODE_ALIASES, "Select encoding",
              "  (#{code_list})") do |encoding|
        options.encoding = encoding
      end

      # Optional argument with keyword completion.
      opts.on("--type [TYPE]", [:text, :binary, :auto],
              "Select transfer type (text, binary, auto)") do |t|
        options.transfer_type = t
      end

      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts ::Version.join('.')
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end # parse()

end # class OptparseExample

options = OptparseExample.parse(ARGV)

puts "-" * 80
puts "OPTIONS:"
puts "-" * 10
longest_key = options.each_pair.map {|option, _| option.size }.max
format = "%#{longest_key}s: %s"
options.each_pair do |option, value|
  puts format % [option, value]
end
puts "-" * 80
puts "ARGV:"
puts "-" * 10
# notice that ARGV *is* modified! args are chomped away
if ARGV.size.zero?
  puts "<no args given>"
else
  longest_index = (Math.log(ARGV.size) / Math.log(10)).floor + 1
  format = "%#{longest_index}d: %s"
  ARGV.each_with_index do |arg, index|
    puts format % [index, arg]
  end
end
puts "-" * 80
