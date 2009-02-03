require 'extensions'

describe Enumerable do
  describe :any_with_index? do
    it "should return false if nothing found" do
      %w[a b c d e f].any_with_index? { |s, i| i==9 }.should == false
    end
    
    it "should return true if any match found" do
      %w[a b c d e f].any_with_index? { |s, i| i==3 }.should == true
    end
    
    it "should stop iterating when match found" do
      h = Hash.new { |h,k| h[k] = k}
      %w[a b c d e f].any_with_index? { |s, i| h[s]=1; i==2}.should == true
      h.keys.size.should == 3
      h.keys.should include("c")
      h.keys.should_not include("d")
    end
  end
end
