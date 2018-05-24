#!/usr/bin/env ruby
# validate a BIN number

class BinChecker
  attr_reader :bin, :allow_test_bins, :quiet

  def initialize(bin, allow_test_bins, quiet)
    @bin = normalize_bin(bin)
    @allow_test_bins = !!allow_test_bins
    @quiet = !!quiet
  end

  def normalize_bin(bin)
    raise ArgumentError, "bin must be a 5 or 6-digit number" unless bin.is_a?(String) && bin =~ /\A\d{5,6}\Z/

    if bin.length == 5
      "0" + bin
    else
      bin
    end
  end

  def to_s
    "#<BinChecker:#{object_id} bin=#{bin.inspect}, allow_test_bins=#{allow_test_bins}, quiet=#{quiet}>"
  end

  def warn(msg)
    return if quiet
    $stderr.puts msg
  end

  def valid?
    puts '-' * 80
    puts bin.inspect
    puts '-' * 80

    # known cases
    if bin == "000000"
      warn "BIN is '000000' which technically has correct checksum but is known to be junk."
      return false
    end

    if allow_test_bins
      if bin[0] != "0"
        warn "This is a test BIN. Checksum should be ignored/considered valid."
        warn "But I'm going to calculate it for you anyway."
        # return true
      end
    end

    check_digit = bin[-1]
    value = check_digit_for(bin[0..4])
    warn "check digit should be #{value}"
    value == check_digit.to_i
  end

  def check_digit_for(bin5)
    check_digit = bin5[-1]
    value = bin5[0..4]

    value = value[4].to_i * 2 + value[0].to_i + value[2].to_i
    value = value / 10 + value % 10
    value = value + bin5[1].to_i + bin5[3].to_i
    value = value % 10
    value = (10 - value) % 10
  end
end

if $0 == __FILE__
  bin = ARGV[0]
  allow_test_bins = ARGV.include?('-t') || ARGV.include?('--test')
  quiet = ARGV.include?('-q') || ARGV.include?('--quiet')
  checker = BinChecker.new(bin, allow_test_bins, quiet)
  puts checker
  puts "Valid Bin? #{bin.inspect} => #{checker.valid?}"
end
