#!/usr/bin/env ruby
# check-for-not-implemented-errors.rb
def run(label)
  print "%-45s : " % label
  begin
    result = yield
    puts "OK (#{result.inspect})"
  rescue NotImplementedError => e
    puts "NotImplementedError (#{e.message})"
  rescue SystemCallError => e
    puts "#{e.class} (#{e.message})"
  rescue => e
    puts "#{e.class} (#{e.message})"
  end
end

# 1) Kernel.syscall — macOS 10.12+ (Ventura/Sonoma/Sequoia) => NotImplementedError
run("Kernel.syscall(0)") do
  syscall(0)
end

# 2) IO#advise — modern macOS implements posix_fadvise; typically OK (returns nil)
run("IO#advise(:sequential)") do
  File.open(__FILE__) { |f| f.advise(:sequential) }
end

# 3) File.stat(...).birthtime — OK on macOS; on platforms lacking birthtime it raises NotImplementedError
run("File.stat(__FILE__).birthtime") do
  File.stat(__FILE__).birthtime
end

# 4) File.lchmod on a symlink — may be NotImplementedError or ENOTSUP on some OSes/filesystems
require "tmpdir"
Dir.mktmpdir do |dir|
  target = File.join(dir, "t.txt")
  link   = File.join(dir, "t.lnk")
  File.write(target, "x")
  File.symlink(target, link)
  run("File.lchmod on symlink") do
    File.lchmod(0o644, link)
  end
end

# 5) Unsupported clock id — example of “unsupported” yielding EINVAL (not NotImplementedError)
run("Process.clock_gettime(:CLOCK_REALTIME_COARSE)") do
  Process.clock_gettime(:CLOCK_REALTIME_COARSE)
end
