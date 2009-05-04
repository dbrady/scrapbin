class HashWithIndignantAccess < Hash
  def [](index)
    unless key? index
      raise "No seriously, can't you keep your data types straight? " if ((String === index && key?(index.to_sym)) || (Symbol === index && key?(index.to_s)))
    end
    super(index)
  end
end


