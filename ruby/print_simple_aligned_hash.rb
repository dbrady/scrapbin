def print_simple_aligned_hash(hash)
  longest_key = hash.keys.map(&:size).max
  format = "%#{longest_key}s: %s"
  hash.each do |key, value|
    puts format % [key, value]
  end
end
