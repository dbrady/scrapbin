class ActiveRecord::Base
  def self.database
    self.connection.send(:instance_variable_get, "@config")[:database]
  end

  def self.describe_table(sorted=false)
    query = "DESCRIBE #{table_name}"
    sort_columns = ["Field"] if sorted
    query_as_table(query, sort_columns)
  end

  def self.show_indexes(sorted=false)
    query = "SHOW INDEXES FROM #{table_name}"
    sort_columns = ["Key_name", "Seq_in_index"] if sorted
    query_as_table(query, sort_columns)
  end
  
  def self.show_processlist(full=false)
    query = full ? "SHOW FULL PROCESSLIST " : "SHOW PROCESSLIST"
    query_as_table(query)
  end
  
  protected

  def self.query_as_table(query, sort_columns=nil)
    print_table(select_rows_with_header(query, sort_columns))
  end
  
  def self.print_table(rows)
    field_lengths = []
    columns = rows[0].length
    
    # determine width of columns (find longest entry in each column)
    (0...columns).each_with_index do |field, idx|
      field_lengths << rows.map {|r| (r[idx] || "").length}.max
    end
    
    format = "| " + ((0...columns).map{|i| "%-#{field_lengths[i]}s"} * ' | ') + " |"
    sep = "+" + ((0...columns).map {|i| '-' * (2+field_lengths[i])} * '+') + "+"
    
    puts sep
    puts format % rows.shift
    puts sep
    rows.each do |row|
      puts format % row
    end
    puts sep
  end
  
  def self.select_rows_with_header(query, sort_columns=nil)
    rows = []
    fields = []
    field_lengths = []

    result = connection.execute(query)
    fields = result.fetch_fields.map(&:name)

    # get columns to sort on
    sort_column_indexes = sort_columns.map {|col| fields.index(col)} if sort_columns
    
    # fetch data
    rows = []
    while(row = result.fetch_row)
      rows << row
    end

    # determine width of columns (find longest entry in each column)
    fields.each_with_index do |field, idx|
      field_lengths << [rows.map {|r| (r[idx] || "").length}.max, field.length].max
    end
    
    # sort the data by sort columns
    rows = rows.sort_by {|r| sort_column_indexes.map {|i| "%#{field_lengths[i]}s" % r[i]} * '' } if sort_columns

    rows.unshift(fields)
    rows
  end
end


