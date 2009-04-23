class File
  # Hides all that lovely expand/join/dirname(__FILE__, path) crap
  # 
  # E.g.: require File.here("../lib/pants")
  # 
  # Splatty version for the OS Agnosts out there:
  # require File.here(%w[.. lib pants])
  def self.here(*args)
    File.expand_path(File.join(File.dirname(caller.last.split(":")[0]), *args))
  end
end
