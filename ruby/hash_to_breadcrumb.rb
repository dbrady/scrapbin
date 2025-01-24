require 'yaml'

def print_breadcrumb_tree(hash, prefix: nil, path: nil)
  hash.each do |key, value|
    joined_key = [prefix, key].compact.join(".")
    if value.is_a?(Hash)
      print_breadcrumb_tree(value, prefix: joined_key, path:)
    else
      full_key = "#{joined_key}: #{value}"
      full_key += " | #{path}" if path
      puts full_key
    end
  end
end

# Example usage with the provided YAML file
file_path = if ARGV.empty?
              File.join(Dir.pwd, 'config/locales/leases/users/contracts/en.yml')
            else
              ARGV.first
            end

nested_hash = YAML.load_file(file_path, aliases: true)
print_breadcrumb_tree(nested_hash, path: file_path)
