# H/T http://stackoverflow.com/questions/8206523/how-to-create-a-deep-copy-of-an-object-in-ruby
#
# Short version that works for most objects: Marshal.load(Marshal.dump(@object))
#
# Pretty sure it doesn't work with lambdas and closures. Then again, not sure if
# this method here does either, but in theory it's a better clone.
#
# Cf. deep_dup in Rails

class Object
  def deep_clone
    return @deep_cloning_obj if @deep_cloning
    @deep_cloning_obj = clone
    @deep_cloning_obj.instance_variables.each do |var|
      val = @deep_cloning_obj.instance_variable_get(var)
      begin
        @deep_cloning = true
        val = val.deep_clone
      rescue TypeError
        next
      ensure
        @deep_cloning = false
      end
      @deep_cloning_obj.instance_variable_set(var, val)
    end
    deep_cloning_obj = @deep_cloning_obj
    @deep_cloning_obj = nil
    deep_cloning_obj
  end
end
