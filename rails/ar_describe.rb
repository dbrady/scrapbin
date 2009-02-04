class ActiveRecord::Base
  #  This is MySQL-specific. Sorry about that. TODO: Refactor me to use the information schema!
  def self.describe(sorted=false)
    puts '--'
    rows = connection.select_all("DESCRIBE #{table_name}")
    rows = rows.sort_by {|r| r["Field"]} if sorted
    longest = Hash.new(0)
    keys = ["Field", "Type", "Null", "Key", "Default", "Extra"]
    keys.each { |k| longest[k] = k.size }
    rows.each { |r| keys.each { |k| s = (r[k] ? r[k].size : 0); longest[k] = s if s > longest[k]}}
    puts longest.inspect
    w = (keys.map { |k| "%-#{longest[k]}s" % k } * ' | ').size
    puts '-' * w
    puts "Table: #{table_name}"
    puts keys.map { |k| "%-#{longest[k]}s" % k } * ' | '
    puts '-' * w
    puts rows.map { |r| keys.map {|k| "%-#{longest[k]}s" % r[k]} * ' | '}
    puts '-' * w
  end
end
