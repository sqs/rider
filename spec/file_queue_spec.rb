require 'spec/spec_helper'
require 'spec/queue_spec'

describe Rider::FileQueue do
  before do
    @q = Rider::FileQueue.new('tmp/colors.q')
    @q.clear
  end
  
  it_should_behave_like "queue"
  
  it "should reveal its filename" do
    @q.filename.should == 'tmp/colors.q'
  end
  
  it "must not have a blank or nil name" do
    lambda { Rider::FileQueue.new(nil) }.should raise_error(ArgumentError) 
    lambda { Rider::FileQueue.new('') }.should raise_error(ArgumentError) 
  end
end