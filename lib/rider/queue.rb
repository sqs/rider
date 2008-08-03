module Rider
  class Queue
    attr_reader :filename
    def initialize(filename)
      raise(ArgumentError, "queues must have a filename") if !filename or filename.empty?
      @filename = filename
    end
    
    def push(item)
      Rider::Debug::debug("Q #{filename} PUSH #{item}")
      File.open(filename, "a") do |file|
        file.puts(item)
      end
    end
    
    def pop
      if empty?
        Rider::Debug::debug("Q #{filename} POP nil")        
        return nil
      end
      lines = File.readlines(filename)
      item = lines.shift.strip
      File.open(filename, "w") do |file|
        file.write(lines.join)
      end
      Rider::Debug::debug("Q #{filename} POP #{item}")
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