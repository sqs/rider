require 'spec/spec_helper'
require 'spec/queue_spec'

describe Rider::AMQPQueue do
  before do
    @q = Rider::AMQPQueue.new('colors')
    @q.clear
  end
  
  #it_should_behave_like "queue"
  
  it "must not have a blank or nil name" do
    lambda { Rider::AMQPQueue.new(nil) }.should raise_error(ArgumentError) 
    lambda { Rider::AMQPQueue.new('') }.should raise_error(ArgumentError) 
  end
end