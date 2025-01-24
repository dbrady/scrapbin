module CreationLogger
  def self.included(base)
    base.class_eval do
      class << self
        def create(*args, &block)
          log_creation_method(:create, self.name, *args)
          super
        end

        def create!(*args, &block)
          log_creation_method(:create!, self.name, *args)
          super
        end

        def find_or_create_by(*args, &block)
          log_creation_method(:find_or_create_by, self.name, *args)
          super
        end

        def find_or_create_by!(*args, &block)
          log_creation_method(:find_or_create_by!, self.name, *args)
          super
        end

        def first_or_create(*args, &block)
          log_creation_method(:first_or_create, self.name, *args)
          super
        end

        def first_or_create!(*args, &block)
          log_creation_method(:first_or_create!, self.name, *args)
          super
        end
      end
    end
  end

  private

  def self.log_creation_method(method_name, class_name, *args)
    Rails.logger.debug "Object Creation: #{class_name}.#{method_name}(#{args.inspect})"
  end
end

# To use it in your models:
# class YourModel < ApplicationRecord
#   include CreationLogger
# end

  # step in front of create, create!, find_or_create_by
