module Rider
  class Queue
    attr_reader :name, :filename
    def initialize(name)
      raise(ArgumentError, "queues must have a name") if !name or name.empty?
      raise(ArgumentError, "queue names must be alphanumeric") if name.match(/[^a-z0-9]/)
      @name = name
      @filename = "tmp/#{name}.queue"
    end
    
    def push(item)
      debug("Q #{name} PUSH #{item}")
      File.open(filename, "a") do |file|
        file.puts(item)
      end
    end
    
    def pop
      if empty?
        debug("Q #{name} POP nil")        
        return nil
      end
      lines = File.readlines(filename)
      item = lines.shift.strip
      File.open(filename, "w") do |file|
        file.write(lines.join)
      end
      debug("Q #{name} POP #{item}")
      return item
    end
    
    def clear
      File.unlink(filename) if File.exist?(filename)
    end
    
    def empty?
      !File.exist?(filename) or File.open(filename).read == ""
    end
  end
end