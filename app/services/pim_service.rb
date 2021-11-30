class PimService
  def initialize(type, method, products=nil)
    @products = products
    @type = type
    @method = method
    @pim_grpc_client = ::Gruf::Client.new(options: {hostname: '0.0.0.0:10542'}, service: ::Pim::Products)
  end

  def call
    send("#{@type}_#{@method}")
  end

  def grpc_create_products
    return unless @products.present?

    request_object = []
    @products.each do |product|
      request_object << Pim::Product.new(name: product[:name], stock: product[:stock])
    end
    response = @pim_grpc_client.call(:CreateProducts, request_object)
    puts response.message.inspect
  rescue Gruf::Client::Error => e
    puts e.error.inspect
  end

  def grpc_get_products
    response = @pim_grpc_client.call(:GetProducts)
    puts response.message.inspect
  rescue Gruf::Client::Error => e
    puts e.error.inspect
  end

  def bunny

  end
end
