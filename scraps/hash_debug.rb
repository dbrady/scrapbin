require 'ruby-debug'

# ----------------------------------------------------------------------
# Debug hash assignments
# 
# Patches a hash instance to break when a given key is set.
# 
# Example:
# 
#  @search = { }
# 
#  @search.set_breakpoint_on_assign :education_level_id
#  @search[:foo] = "bar"
#  @search[:education_level_id] = "2"  # triggers debugger
#  @search.clear_breakpoint_on_assign :education_level_id
#  @search[:education_level_id] = "3"  # doesn't trigger
#  @search[:bar] = "baz"
unless Hash.private_instance_methods.include?("assignment_breakpoints")
  class Hash
    alias :orig_set :[]=
      
    def set_breakpoint_on_assign(key)
      assignment_breakpoints[key] = true
    end
    
    def clear_breakpoint_on_assign(key)
      assignment_breakpoints.delete(key)
    end
    
    def []=(key,value)
      debugger if assignment_breakpoints.key? key
      orig_set key, value
    end
    
    private
    def assignment_breakpoints
      @__assignment_breakpoints ||= {}
    end 
  end
end

