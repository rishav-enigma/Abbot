class OrdersController < ::Gruf::Controllers::Base
  bind ::Oms::Orders::Service

  def get_order
    order = ::Order.find(request.message.id.to_i)
    Oms::GetOrderResp.new(
      order: Oms::Order.new(
        id: order.id,
        number: order.number,
        total: order.total
      )
    )
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace)
    fail!(:not_found, :order_not_found, "Failed to find Order with ID: #{request.message.id}")
  end

  def get_orders
    return enum_for(:get_orders) unless block_given?
    orders = ::Order.all
    orders.each do |order|
      yield order.to_proto
    end
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace)
    fail!(:internal, :unknown, "Unknown error when listing Orders: #{e.message}")
  end

  def create_orders
    orders = []
    request.messages do |message|
      orders << Order.create(number: message.number, total: message.total).to_proto
    end
    Oms::CreateOrdersResp.new(orders: orders)
  end

  def create_products_in_stream
    request.messages.each do |r|
      yield Order.create(number: r.number, total: r.total).to_proto
    end
  end
end