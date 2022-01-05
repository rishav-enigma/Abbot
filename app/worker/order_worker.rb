class OrderWorker
  include Sneakers::Worker
  from_queue :CreateOrder

  def work(msg)
    #p msg
    CreateOrderJob.perform(msg)
    ack!
  end

end
