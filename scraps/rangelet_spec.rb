# require File.dirname(__FILE__) + '/../spec_helper'
require 'rangelet'

describe Rangelet do
  it "should be creatable from a single argument" do
    r = Rangelet.new 5
    r.first.should == 5
    r.last.should == 5
  end
    
  it "should be creatable from two arguments" do
    r = Rangelet.new 5, 8
    r.first.should == 5
    r.last.should == 8
  end  
  
  it "should sort out-of-order arguments" do
    r = Rangelet.new 8, 5
    r.first.should == 5
    r.last.should == 8
  end
  
  it "should put an array-consuming factory function in Array" do
    arr = [1,2,3,4,5]
    r = arr.shift_rangelet
    arr.size.should == 0
    r.first.should == 1
    r.last.should == 5
  end
  
  it "should only consume contiguous elements in factory function" do
    arr = [1,2,3,4,5,8,9,10]
    r = arr.shift_rangelet
    arr.size.should == 3
    arr.should == [8,9,10]
    r.first.should == 1
    r.last.should == 5
  end
    
  it "should put a group-consumption factory function in Array" do
    arr = [1,2,3,4,5,8,9,10]
    rr = arr.to_rangelets
    arr.should == [1,2,3,4,5,8,9,10]
    rr.size.should == 2
    rr[0].first.should == 1
    rr[0].last.should == 5
    rr[1].first.should == 8
    rr[1].last.should == 10
  end
  
  it "should return nil from Array.shift_rangelet! if array is empty" do
    arr = []
    r = arr.shift_rangelet
    r.should be_nil
  end
    
  it "should return 'first-last' from to_s" do
    r = Rangelet.new(1,5)
    r.to_s.should == '1-5'
  end

  it "should return a single digit from to_s if first==last" do
    r = Rangelet.new(3,3)
    r.to_s.should == '3'
  end

  it "should autocast to strings with join" do
    [1,2,3,4,5,7,9,10,11,12,13].to_rangelets.join(",").should == '1-5,7,9-13'
  end
  
  it "should be back-castable to Array" do
    r = Rangelet.new(1,6)
    r.to_a.should == [1,2,3,4,5,6]
  end
  
  it "should back-cast entire Arrays correctly" do
    arr = [1,3,4,5,7,8,9]
    arr.to_rangelets.join(",").should == "1,3-5,7-9"
    arr.to_rangelets.from_rangelets.should == arr
  end
  
  it "should sort arrays before generating rangelets" do
    r = "1,4,3,5,9,8,7".split(",").map {|i| i.to_i}.to_rangelets
    r.from_rangelets.join(",").should == "1,3,4,5,7,8,9"
  end
end