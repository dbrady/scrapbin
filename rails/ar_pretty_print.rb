class ActiveRecord::Base
  def pretty_print!(o=$stdout)
    longest_key = attributes.keys.map(&:size).max
    format = "  %#{longest_key}s: "
    puts "{ #{self.class.to_s.split(/\(/).first}"
    attributes.each do |name, value|
      print format % name
      puts value
    end
    puts "}"
  end
end
