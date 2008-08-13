require 'spec/spec_helper'

shared_examples_for "queue" do
  it "must not have a blank or nil name" do
    lambda { Rider::Queue.new(nil) }.should raise_error(ArgumentError) 
    lambda { Rider::Queue.new('') }.should raise_error(ArgumentError) 
  end

  it "should be empty after clearing" do
    @q.clear
    @q.empty?.should == true
  end
    
  it "should push then shift one item" do
    @q.push('blue')
    @q.shift.should == 'blue'
  end
  
  describe "when empty" do
    it "should return nil if shifted" do
      @q.shift.should == nil
    end
  end
  
  it "should not clobber the queue upon initialization"
end

describe Rider::Queue do
  before do
    @q = Rider::Queue.new('tmp/colors.q')
    @q.clear
  end
  
  after do
    @q.clear
  end
  
  it "should push then shift multiple items" do
     %w(red green orange).each { |color| @q.push(color) }
     puts "POP x 3"
     [@q.shift, @q.shift, @q.shift].should == %w(red green orange)
   end
end