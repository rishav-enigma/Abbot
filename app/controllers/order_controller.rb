class OrderController < ApplicationController
	
	def create_order(payload)
    payload = JSON.parse(payload) 
		order_number = payload["number"]
		stock = payload["price"]
		Order.find_or_create_by(number: order_number, price: price)
	end
	
  def get_payload_and_create_order
    consumer = ConsumerServices.new
    queue = consumer.declare_queue("CreateOrder")
    payload = consumer.consume_message(queue)
    create_order(payload) if payload.present?
    return false
  end
	
  def send_request_to_create_product(product_name, stock, queue_name)
    publisher = PublisherServices.new
    queue = publisher.declare_queue("CreateProduct")
    payload = { name: product_name, stock: stock}
    payload = payload.to_json
    publisher.publish_message(payload, queue.name)
    publisher.close_connection
  end

end
