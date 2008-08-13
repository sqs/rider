require 'spec/spec_helper'
require 'spec/queue_spec'

describe Rider::HostPartitionedQueue do
  it_should_behave_like "queue"
  
  before do
    @q = Rider::HostPartitionedQueue.new('test')
  end
  
  it "should alternate among hosts when popping" do
    %w(http://example.com/path1 http://example.com/path2 http://example.net/ http://localhost/path).each { |u| @q.push(u) }
    [@q.pop, @q.pop, @q.pop, @q.pop].should ==
      %w(http://example.com/path1 http://example.net/ http://localhost/path http://example.com/path2)
  end
  
  it "should return the same host if only one distinct host exists" do
    %w(http://example.com/path1 http://example.com/path2 http://example.com/path3).each { |u| @q.push(u) }
    [@q.pop, @q.pop, @q.pop].should == %w(http://example.com/path1 http://example.com/path2 http://example.com/path3)
  end
end