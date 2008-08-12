module Rider
  class Crawler
    # Creates a new Crawler, with the specified +mask+ (a Regexp) and queue (a +Rider::Queue+ instance).
    def initialize(mask, queue)
      @mask = mask
      @queue = queue
      @seen_urls = []
      @www = WWW::Mechanize.new { |a| a.log = Logger.new("tmp/www.log") }
    end
    
    # Returns true if +url+ passes the +mask+.
    def match_mask?(url)
      @mask.match(url) != nil
    end
    
    # Crawls documents and passes their URL, response headers, and data to the supplied block.
    def each_document
      while doc_data = next_document()
        follow_urls = yield(doc_data) || []
        add_follow_urls(follow_urls)
      end
    end
    
    def add_follow_urls(urls)
      urls.each { |url| @queue.push(url) if follow_url?(url) }
    end
    
    def follow_url?(url)
      match_mask?(url) and !seen_url?(url)
    end
    
    SKIPPABLE_EXCEPTIONS = [Errno::ETIMEDOUT, WWW::Mechanize::ResponseCodeError, Errno::EHOSTUNREACH, SocketError,
                            Errno::ECONNREFUSED, Timeout::Error, Net::HTTPBadResponse]
    # Returns the next retrievable document from the next valid URL in the queue.
    def next_document
      begin
        url = next_url()
        return nil if url.nil?
        doc_data = get(url)
        saw_url(url)
        return doc_data
      rescue Exception=>ex
        if SKIPPABLE_EXCEPTIONS.include?(ex.class)
          Rider.log.debug("EXCEPTION: #{ex.inspect}, skipping...")
          retry # go on to the next document
        else
          raise ex
        end
      end
    end
    
    # Gets the document at the specified +url+. Returns an Array [uri, metadata, contents]
    def get(url)
      uri = URI.parse(url)
      case uri.scheme
      when 'http'
        get_http(uri)
      when 'file'
        get_file(uri)
      else
        raise(ArgumentError, "don't know how to get #{url}")
      end
    end
    
    def get_file(uri)
      filename = uri.gsub(/^file:\/\//, '')
      [uri, {}, File.read(filename)]
    end
    
    def get_http(uri)
      page = @www.get(uri)
      meta = page.response
      [uri, meta, page.body]
    end
    
    # Retrieves the next URL in the queue that matches the +mask+.
    def next_url
      while url = @queue.pop
        return url if match_mask?(url) and !seen_url?(url)
      end
    end
    
    def seen_url?(url)
      @seen_urls.include?(url)
    end
    
    def saw_url(url)
      @seen_urls << url
    end
  end
end