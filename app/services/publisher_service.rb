class PublisherServices 
  
  attr_accessor :new_connection, :channel
  def initialize(hostname, port)
    @new_connection = BaseService.new(hostname, port)
    @new_connection.start
    @channel = @new_connection.create_channel
  end

  #Declaring a queue is idempotent - it will only be created if it doesn't exist already
  # durable: true make sures that queue will survive a RabbitMQ node restart
  def declare_queue(queue_name = "default", durable = false)
    @channel.queue(queue_name, durable: durable)
  end

  # persistent: true it tells RabbitMQ to save the message to disk
  def publish_message(routing_key, msg, persistent = false)
    @channel.default_exchange.publish(msg, routing_key: routing_key, persistent: persistent)
  end

  def close_connection
    @new_connection.close  
  end
end