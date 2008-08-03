require 'spec/spec_helper'

describe Rider::Queue do
  before do
    @q = Rider::Queue.new('colors')
    @q.clear
  end
  
  after do
    @q.clear
  end
  
  it "should not clobber the queue upon initialization"
  
  it "should reveal its name" do
    @q.name.should == 'colors'
  end
  
  it "must not have a blank or nil name" do
    lambda { Rider::Queue.new(nil) }.should raise_error(ArgumentError) 
    lambda { Rider::Queue.new('') }.should raise_error(ArgumentError) 
  end
  
  it "must have an alphanumeric name" do
    lambda { Rider::Queue.new('/') }.should raise_error(ArgumentError) 
  end
  
  it "should reveal its filename" do
    @q.filename.should == 'tmp/colors.queue'
  end
  
  it "should be empty after clearing" do
    @q.empty?.should == true
  end
    
  it "should push then pop one item" do
    @q.push('blue')
    @q.pop.should == 'blue'
  end
  
  it "should push then pop multiple items" do
    #hie File.read(@q.filename)
    %w(red green orange).each { |color| @q.push(color) }
    [@q.pop, @q.pop, @q.pop].should == %w(red green orange)
  end
  
  describe "when empty" do
    it "should return nil if popped" do
      @q.pop.should == nil
    end
  end
  
  it "should be thread-safe" do
    pending "it is not thread-safe yet, obviously"
  end
end