class Client
  attr_accessor :call_id, :lock, :condition, :reply_queue, :exchange, :params, :response, :server_queue_name, :channel, :reply_queue_name

  def initialize
    @channel = channel
    @exchange = channel.default_exchange
    @server_queue_name = "CreateProd"
    @reply_queue_name = "ReplyCreateProduct"
    @params = {name: "Hello World"}
  end

  def setup_reply_queue
    # @lock = Mutex.new
    # @condition = ConditionVariable.new
    that = self
    @reply_queue = channel.queue(reply_queue_name, durable: true)

    PL_LOG.info "#{reply_queue}"
    reply_queue.subscribe do |_delivery_info, properties, payload|
      PL_LOG.info "Got The Response from #{reply_queue.name} => #{payload} #{properties} #{properties[:correlation_id]}"
      if properties[:correlation_id] == that.call_id
        PL_LOG.info "Its Correct"
        that.response = payload
        # sends the signal to continue the execution of #call
        #that.lock.synchronize { that.condition.signal }
      end
    end
  end

  def call
    @call_id = "NAIVE_RAND_#{rand}#{rand}#{rand}"
    PL_LOG.info "Request => #{params} Sent to #{server_queue_name} waiting from reply #{reply_queue_name}"
    p = exchange.publish(params.to_json,
                     routing_key: server_queue_name,
                     correlation_id: call_id,
                     reply_to: reply_queue_name)
    setup_reply_queue
    #lock.synchronize { condition.wait(lock) }
    PL_LOG.info response
    response
  end

  def channel
    @channel ||= connection.create_channel
  end

  def connection
    @connection ||= Bunny.new.tap { |c| c.start }
  end

  def value
    response
  end
end
