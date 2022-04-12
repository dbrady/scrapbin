# stupid hack to find out who is calling methods on our object

# Comment out the entire file and clip off an < ParentClass, then jam this in and stand back.

# Note: older rubies don't take **kwargs to method_missing.

# TODO: Make this log caller location?
# TODO: Make this a module/class insert?
class Widget
  def method_missing(name, *args, **kwargs)
    File.open(Rails.root + "widget_calls.txt", "a") {|fp| fp.puts "#{Time.now.strftime('%T')}: ##{name}(#{args.join(', ')}) [kwargs: #{kwargs.inspect}]" }
  end

  def self.method_missing(name, *args)
    File.open(Rails.root + "widget_calls.txt", "a") {|fp| fp.puts "#{Time.now.strftime('%T')}: .#{name}(#{args.join(', ')}) [kwargs: #{kwargs.inspect}]" }
  end
end
