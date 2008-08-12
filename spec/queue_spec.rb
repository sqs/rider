require 'spec/spec_helper'

shared_examples_for "queue" do
  after do
    @q.clear
  end

  it "should be empty after clearing" do
    @q.clear
    @q.empty?.should == true
  end
    
  it "should push then pop one item" do
    @q.push('blue')
    @q.pop.should == 'blue'
  end
  
  it "should push then pop multiple items" do
    %w(red green orange).each { |color| @q.push(color) }
    puts "POP x 3"
    [@q.pop, @q.pop, @q.pop].should == %w(red green orange)
  end
  
  describe "when empty" do
    it "should return nil if popped" do
      @q.pop.should == nil
    end
  end
  
  it "should not clobber the queue upon initialization"
end