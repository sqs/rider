module Rider
  class HostPartitionedQueue
    attr_reader :name
    
    def initialize(name)
      @name = name
      clear
    end
    
    def push(url)
      host = get_host(url)
      @hosts << host unless @hosts.include?(host)
      @urls_by_host[host] ||= []
      @urls_by_host[host] << url
      return true
    end
    
    def shift
      if empty?
        Rider.log.debug("Q #{name} POP nil")        
        return nil
      end
      host = @hosts[@current_host_index]
      puts "\n\nHOSTS:#{@hosts.inspect}\nURLS:#{@urls_by_host.inspect}\nHOSTIDX:#{@current_host_index}\n"
      url = @urls_by_host[host].shift
      
      if @urls_by_host[host].empty?
        @hosts.delete_at(@current_host_index) 
        @urls_by_host.delete(host)
        # no need to increment @current_host_index since we just effectively pushed every element down by one
        # by deleting from @hosts, UNLESS it was the last item in the array, in which case that index doesn't
        # exist anymore
        increment_current_host_index if @current_host_index == @hosts.length
      else
        increment_current_host_index
      end
      return url
    end
    
    def clear
      @urls_by_host = {}
      @hosts = []
      @current_host_index = 0
    end
    
    def empty?
      @hosts.empty?
    end
    
    private
    def get_host(url)
      URI.parse(url).host
    end
    
    def increment_current_host_index
      if @hosts.length == 0
        @current_host_index = 0
      else
        # increment by one but go back to 0 if it exceeds the length of the array
        @current_host_index = (@current_host_index + 1) % @hosts.length
      end
    end
  end
end