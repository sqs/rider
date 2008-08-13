module Rider
  class AMQPQueue < Rider::Queue
    attr_reader :name
    
    def initialize(name)
      raise(ArgumentError) if !name or name.empty?
      @name = name
      connect()
    end
    
    def push(item)
      
    end
    
    def pop
      
    end
    
    def clear
      
    end
    
    def empty?
      
    end
    
    private
    
    def connect
      EM.run do
        Rider.log.debug("Connecting to AMQP server at localhost...")
        @connection = AMQP.connect(:host => 'localhost', :logging => false)
        @channel = MQ.new(@connection)
        @queue = MQ::Queue.new(@channel, name)
        @exchange = MQ::Exchange.new(@channel, :fanout, 'all queues')
        @queue.bind(@exchange)
        Rider.log.debug("Connection to AMQP server established, queue #{name.inspect} declared")
      end
    end
  end
end