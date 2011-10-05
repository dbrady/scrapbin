# rogerify - Take a class and create aliases for all of its
# methods that are acronyms of the original methods.
#
# GOOD HEAVENS, PEOPLE, THIS IS PRANK CODE - DO NOT EVER USE THIS!
# "roger" is used here in the slang sense meaning a very personal
# bodily violation...
#
# NOTES:
#
# * If abbreviations collide, the first abbreviation is left alone and
#   subesquent abbreviations have a decimal suffix appended, starting
#   at 2, e.g. "fb", "fb2", "fb3".
#
# * If an alias collides with an existing method name, the original
#   method is renamed, with "_orig" appended to it. This is to make
#   sure that every new acronym is valid and where you expect it.
#
class String
  # given a method name (string), returns it abbreviated Roger-style
  # e.g. "this_is_a_string" -> "tias", "what_is_that?" -> "wit?"
  def rogerify
    self.gsub(/([a-z])[a-z]+/, '\1').gsub(/_/,'')
  end

  # Add lowest decimal number to this string to make it not be
  # included in ray. Skips 0 and 1, so first decimal suffix is
  # 2. Returns base with no suffix if !ray.include?(base)
  def rogerify_suffix(ray)
    i=1
    base = str = self
    while ray.include? str
      str = "#{base}#{i+=1}"
    end
    str
  end

  def rogerify_suffix!(ray)
    self.replace rogerify_suffix(ray)
  end
end


class Object
  def self.rogerify!
    sm = self.singleton_methods.sort
    replace_class_method = lambda do |newmethod, oldmethod|
      newmethod = newmethod.gsub(/\?/,'') + "?" if newmethod =~ /\?.+$/
      newmethod = newmethod.gsub(/\!/,'') + "!" if newmethod =~ /\!.+$/
      replace_class_method.call(newmethod + "_orig", newmethod) if self.singleton_methods.include?(newmethod)
      puts "#{self.name}.#{oldmethod} -> #{self.name}.#{newmethod}"
      class <<self; self; end.send :alias_method, newmethod.to_sym, oldmethod.to_sym
    end
    sm.each do |method|
      old_method = method
      new_method = method.rogerify
      next if old_method == new_method
      new_method.rogerify_suffix!(self.singleton_methods - sm)
      replace_class_method.call(new_method, old_method)
    end

    im = self.instance_methods.sort
    replace_method = lambda do |newmethod, oldmethod|
      newmethod = newmethod.gsub(/\?/,'') + "?" if newmethod =~ /\?.+$/
      newmethod = newmethod.gsub(/\!/,'') + "!" if newmethod =~ /\!.+$/
      replace_method.call(newmethod + "_orig", newmethod) if self.instance_methods.include?(newmethod)
      puts "#{oldmethod} -> #{newmethod}"
      alias_method newmethod.to_sym, oldmethod.to_sym
    end
    im.each do |method|
      old_method = method
      new_method = method.rogerify
      next if new_method == old_method
      new_method.rogerify_suffix!(self.instance_methods - im)
      replace_method.call(new_method, old_method)
    end
  end
end

class Foo
  def foo_bar_baz
    42
  end
  def foo_bar_bar
    420
  end
  def foo_bar_baq
    4200
  end
  def baz_bar_foo!
    43
  end
  def bar_foo_baz?
    44
  end
  def to_yaml_per_echo # force an alias of type
    45
  end

  def self.foo_bar_baz
    13
  end
  def self.foo_bar_bar
    130
  end
  def self.foo_bar_baq
    1300
  end
  def self.baz_bar_foo!
    14
  end
  def self.bar_foo_baz?
    15
  end
end


if __FILE__ == $0
  Foo.rogerify!
  Foo.rogerify!
  puts "-" * 80
  puts "Foo.bar_foo_baz? #{Foo.bar_foo_baz?}"
  puts "f.baz_bar_foo! #{Foo.new.baz_bar_foo!}"
  puts "Foo.bfb? #{Foo.bfb?}"
  puts "f.bbf! #{Foo.new.bbf!}"
  puts "Foo.bar_foo_baz_orig? #{Foo.bfb_orig?}"
  puts "f.baz_bar_foo_orig! #{Foo.new.bbf_orig!}"
end
