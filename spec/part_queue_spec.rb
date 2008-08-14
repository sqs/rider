require 'spec/spec_helper'
require 'spec/queue_spec'

describe Rider::HostPartitionedQueue do
  it_should_behave_like "queue"
  
  before do
    @q = Rider::HostPartitionedQueue.new('test')
  end
  
  it "should alternate among hosts when shifting" do
    %w(http://example.com/path1 http://example.com/path2 http://example.net/ http://localhost/path).each { |u| @q.push(u) }
    [@q.shift, @q.shift, @q.shift, @q.shift].should ==
      %w(http://example.com/path1 http://example.net/ http://localhost/path http://example.com/path2)
  end
  
  it "should return the same host if only one distinct host exists" do
    %w(http://example.com/path1 http://example.com/path2 http://example.com/path3).each { |u| @q.push(u) }
    [@q.shift, @q.shift, @q.shift].should == %w(http://example.com/path1 http://example.com/path2 http://example.com/path3)
  end
  
  it "should be equal to another queue with the same objects and state" do
    @q2 = Rider::HostPartitionedQueue.new('test2')
    %w(http://example.com/path1 http://example.com/path2 http://example.net/ http://localhost/path).each { |u| @q.push(u) }
    %w(http://example.com/path1 http://example.com/path2 http://example.net/ http://localhost/path).each { |u| @q2.push(u) }
    @q.should == @q2
  end
  
  describe "when serializing" do
    it "should write and read itself back" do
      %w(http://example.com/path1 http://example.com/path2 http://example.net/ http://localhost/path).each { |u| @q.push(u) }
      @q.serialize
      Rider::HostPartitionedQueue.unserialize('test').should == @q
    end
    
    it "should return nil if asked to unserialize from a nonexistent file" do
      Rider::HostPartitionedQueue.unserialize('nonexistent').should == nil
    end
  end
end