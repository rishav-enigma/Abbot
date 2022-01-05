class OrderController < ApplicationController

  def self.send_request_to_create_product(product_name, stock)
    time = Time.now
    publisher = PublisherService.new
    queue = publisher.declare_queue("CreateProduct")
    payload = { name: product_name, stock: stock}
    #payload = payload.to_json
    # for value in 1..5 do
      payload = { name: product_name, stock: stock}
      publisher.publish_message(queue.name, payload.to_json)
    # end
    publisher.close_connection
    time = Time.now - time
    puts "Total time taken : #{time.seconds}"
  end

end
