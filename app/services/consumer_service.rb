class ConsumerServices 
  
  attr_accessor :new_connection, :channel
  def initialize(hostname, port)
    @new_connection = BaseService.new(hostname, port)
    @new_connection.start
    @channel = @new_connection.create_channel
    # This tells RabbitMQ not to give more than one message to a worker at a time. 
    # Or, in other words, don't dispatch a new message to a worker 
    # until it has processed and acknowledged the previous one
     
    @channel.prefetch(1)
  end

  # Declaring a queue is idempotent - it will only be created if it doesn't exist already
  # durable: true make sures that queue will survive a RabbitMQ node restart
  def declare_queue(queue_name = "default", durable = false)
    @channel.queue(queue_name, durable: durable)
  end

  def consume_message(queue)
    begin
      # block: true is only used to keep the main thread
      # alive. Please avoid using it in real world applications.
      # manual_ack: Just to get manual acknowledgment
      # If ack not received RabbitMQ will understand that a message wasn't processed fully and will re-queue it
      queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, payload|
        puts " [x] Received '#{payload}'"
        channel.ack(delivery_info.delivery_tag)
        close_connection
        return payload
      end
    rescue Interrupt => _
      close_connection
    end
    return false
  end

  def close_connection
    @new_connection.close  
  end
end