class OrderWorker
  include Sneakers::Worker
  from_queue :ReplyCreateProduct

  def work(msg)
    #p msg
    CreateOrderJob.perform(msg)
    ack!
  end

end
