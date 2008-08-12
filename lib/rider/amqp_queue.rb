module Rider
  class AMQPQueue < Rider::Queue
    def initialize(name)
      raise(ArgumentError) if !name or name.empty?
    end
    
    def push(item)
      
    end
    
    def pop
      
    end
    
    def clear
      
    end
    
    def empty?
      
    end
  end
end