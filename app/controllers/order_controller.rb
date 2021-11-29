class OrderController < ApplicationController
	
	def self.create_order(payload)
    payload = JSON.parse(payload) 
		order_number = payload["number"]
		price = payload["price"]
		Order.find_or_create_by(number: order_number, price: price)
	end
	
  def self.get_payload
    consumer = ConsumerService.new
    queue = consumer.declare_queue("CreateOrder")
    payload = consumer.consume_message(queue)
    puts "Payload Received #{payload}"
    OrderController.create_order(payload) if payload.present?
    return false
  end
	
  def self.send_request_to_create_product(product_name, stock)
    publisher = PublisherService.new
    queue = publisher.declare_queue("CreateProduct")
    payload = { name: product_name, stock: stock}
    payload = payload.to_json
    publisher.publish_message(queue.name, payload)
    publisher.close_connection
  end

end
