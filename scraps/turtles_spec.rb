#!/usr/bin/env ruby -w
#
# No warranty. And definitely no refunds.
#

require 'turtles'

class Bar; def spoo; 42; end; end

class Foo
  attr_reader :bar
  def initialize()
    @bar = Bar.new
  end
end

def break_something!
  raise RuntimeError, "Oops! I bwoke something!"
end

describe Turtles, "Basic Behavior" do
  before(:each) do
    @foo = Foo.new
    @arr = [1,2,3]
    no_turtles!
  end
  
  it "should not affect regular object chaining" do
    with_turtles { @foo.bar.spoo }.should == 42
  end
  
  it "should return nil when a method is invoked on Nil" do
    with_turtles { nil.bar }.should == nil
  end
  
  it "should allow a block to return correctly" do
    with_turtles { @arr.collect {|f| f*2} }.should == [2,4,6]
  end
  
  it "should return nil from a block when the block is invoked on nil" do
    with_turtles { nil.collect {|f| f*2} }.should == nil
  end
  
  it "should return nil when global turtles are enabled" do
    turtles!
    nil.bar.spoo.should == nil
    nil.collect {|f| f*2}.should == nil
  end
  
  it "should leave turtles enabled or disabled as they were before with_turtles" do
    no_turtles!
    with_turtles { nil.bar.spoo }.should == nil
    turtles?.should == false
    
    turtles!
    with_turtles { nil.bar.spoo }.should == nil
    turtles?.should == true
  end
  
  it "should not leave the turtle block when nils are found" do
    with_turtles do
      nil.bar.spoo.should == nil
      @foo.bar.spoo.should == 42
      nil.collect {|f| f*2}.should == nil
      @arr.collect {|f| f*2}.should == [2,4,6]
    end
  end
  
  it "should ensure turtles deactivation if code raises an exception" do
    begin
      with_turtles { break_something! }
    rescue RuntimeError
      nil
    end
    turtles?.should == false
  end
end
