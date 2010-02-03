# Thanks to Giles Bowkett for the original idea: http://gilesbowkett.blogspot.com/2009/04/unshiftfiledirnamefile.html
class File
  # Returns the fully expanded joined path relative to the calling file's path.
  # E.g. If your code file is in ~bob/project/code/foo.rb, and you call File.here(%w{.. test foo_test})
  # it will return "/home/bob/project/test/foo_test"
  def self.here(*paths)
    expand_path(join(dirname(__FILE__), paths))
  end
end
