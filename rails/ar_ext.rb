require 'ruport'

class ActiveRecord::Base
  #  This is MySQL-specific. Sorry about that. TODO: Refactor me to use the information schema!
  def self.describe_table(sorted=false)
    table = Ruport::Data::Table(%w[Field Type Null Key Default Extra])
    rows = connection.select_all("DESCRIBE #{table_name}")
    rows = rows.sort_by {|r| r["Field"]} if sorted
    rows.each do |row|
      table << row
    end
    puts table
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
    table = Ruport::Data::Table(["Relation", "Class"])
    self.reflect_on_all_associations.sort_by { |a| "%-100s%-100s" % [a.macro, a.name]}.each do |mr|
      table << { "Relation" => mr.macro.to_s, "Class" => mr.name.to_s }
    end
    puts table
  end
end
