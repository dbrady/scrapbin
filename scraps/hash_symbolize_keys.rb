# hash_symbolize_keys

class Hash
  # 
  def symbolize_keys(recursive=false)
    keys.each do |key|
      self[key.to_sym] = self[key] unless Symbol === key
    end
    delete_if { |key, val| !(Symbol === key) }
    values.each {|v| v.symbolize_keys(true) if Hash === v } if recursive
  end
end
