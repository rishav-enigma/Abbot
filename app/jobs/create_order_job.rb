class CreateOrderJob < ApplicationJob
  
  def self.perform(payload)
    payload = JSON.parse(payload) 
		order_number = payload["number"]
		price = payload["price"]
		Order.find_or_create_by(number: order_number, price: price)
  end
end