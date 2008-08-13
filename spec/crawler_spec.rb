require 'spec/spec_helper'

describe Rider::Crawler do
  before do
    @queue = Rider::Queue.new('web')
    @crawler = Rider::Crawler.new(/http:\/\/localhost/, @queue)
  end
  
  describe "when checking URLs against mask" do
    it "should return true for a URL that matches the mask" do
      @crawler.match_mask?("http://localhost/some/path").should == true
    end
    
    it "should return false for a URL that does not match the mask" do
      @crawler.match_mask?("http://example.com/some/path").should == false
    end
  end
  
  describe "when checking URL validity" do
    before do
      @urls = %w(http://example.com/invalid http://localhost/valid http://localhost/valid/unseen)
    end
    
    it "should return URLs matching the mask" do
      @urls.select { |url| @crawler.valid_url?(url) }.should == ["http://localhost/valid", "http://localhost/valid/unseen"]
    end
    
    it "should return only unseen URLs" do
      @crawler.saw_url('http://localhost/valid')
      @urls.select { |url| @crawler.valid_url?(url) }.should == ['http://localhost/valid/unseen']
    end
  end
  
  describe "when determining URLs to follow" do
    it "should follow URLs that match the mask" do
      @crawler.follow_url?('http://localhost/abc').should == true
    end
    
    it "should not follow URLs that don't match the mask" do
      @crawler.follow_url?('http://invalid.com').should == false
    end
    
    it "should follow URLs that haven't been seen"
    it "should not follow URLs that have been seen already"
  end
  
  describe "when getting the next document" do
    
  end
  
  describe "when getting documents" do
    it "should raise an error for schemes other than http and file" do
      lambda { @crawler.get('ftp://example.com') }.should raise_error(ArgumentError)
    end
    
    describe "when getting file:// documents" do
      before do
        @filename = File.expand_path(File.join(File.dirname(__FILE__), 'data', 'apples.html'))
        @file_uri = 'file://' + @filename
      end
      
      it "should return an array whose first element is the uri" do
        @crawler.get_file(@file_uri)[0].should == @file_uri
      end
      
      it "should return an array whose second element is blank metadata" do
        @crawler.get_file(@file_uri)[1].should == {}
      end
      
      it "should return an array whose third element is the file contents" do
        @crawler.get_file(@file_uri)[2].should == File.read(@filename)
      end
    end
    
    describe "when getting http:// documents" do
      before do
        @doc_uri = 'http://localhost/simplewikipedia/articles/a/l/g/Algebra.html'
      end
      
      it "should return an array whose first element is the uri" do
        @crawler.get_http(@doc_uri)[0].should == @doc_uri
      end
      
      it "should return an array whose second element is blank metadata" do
        meta = @crawler.get_http(@doc_uri)[1]
        meta['Content-type'].should == 'text/html'
      end
      
      it "should return an array whose third element is the file contents" do
        @crawler.get_http(@doc_uri)[2].match(/Algebra is taught in school/).should_not == nil
      end
    end
  end
end