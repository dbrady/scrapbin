# I know, I know, class <<self blah blah blah. Whatever. THIS IS BETTER SHUT UP
unless Object.respond_to? :define_class_method
  class Object
    # define_class_method
    def self.define_class_method ( name, &block )
      klass = class << self; self; end
      klass.send :define_method, name, &block
    end
  end
end
