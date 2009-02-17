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

  # Returns an array of distinct values from a column
  def self.distinct(attribute)
    self.connection.select_values("SELECT DISTINCT(#{attribute}) FROM #{self.table_name}")
  end
  
  # Returns an array of pairs, first the distinct value of a column, second the number of occurrences
  def self.distinct_counts(attribute)
    self.connection.select_rows("SELECT DISTINCT(#{attribute}), COUNT(*) FROM #{self.table_name} GROUP BY 1 ORDER BY 2").map {|sym,ct| [sym, ct.to_i]}
  end

  # Draw the reflections/associations from this class.
  def self.draw_reflections
    longest_macro = self.reflect_on_all_associations.map { |mr| mr.macro.to_s.length }.max
    longest_name = self.reflect_on_all_associations.map {|mr| mr.name.to_s.length }.max
    puts "#{self.class_name}"
    puts "-" * (longest_macro + longest_name + 2)
    self.reflect_on_all_associations.sort {|a,b| a.macro.to_s+" "+a.name.to_s <=> b.macro.to_s+" "+b.name.to_s }.each do |mr|
      puts "#{mr.macro.to_s.ljust(longest_macro, ' ')}  #{mr.name}"
    end
    nil
  end
end
