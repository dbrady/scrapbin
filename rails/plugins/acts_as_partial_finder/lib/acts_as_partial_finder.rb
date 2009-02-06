require 'define_class_method'

# TODO: Rails 2.0 may do SQL caching. Investigate this. (Note that using
# "LIKE" clauses is typically reflective of nonoptimized thinking so it may
# well be "investigate and then discard")

# ActsAsPartialFinder

module ActsAsPartialFinder
  def acts_as_partial_finder(name, *options)
    fields = [name]
    if !options.size.zero? && options[0].key?(:fields)
      fields = options[0][:fields]
    end

    define_class_method "find_by_partial_#{name}" do |term, *opt|
      conds = fields.map {|f| "#{f} LIKE \"%#{term}%\""}.join(" OR ")
      opt[0] ||= Hash.new()
      # append to conditions if any, else init conditions
      opt[0][:conditions] = [opt[0][:conditions], "(#{conds})"].compact.join(" AND ")
      self.find(:all, *opt)
    end
  end
end
