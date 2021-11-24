require 'app/proto/Orders_services_pb'

Gruf.configure do |c|
  c.server_binding_url = '0.0.0.0:10541'
  c.backtrace_on_error = !Rails.env.production?
  c.use_exception_message = !Rails.env.production?
  c.rpc_server_options = {
    pool_size: ENV.fetch('GRPC_SERVER_POOL_SIZE', 100).to_i,
    pool_keep_alive: ENV.fetch('GRPC_SERVER_POOL_KEEP_ALIVE', 1).to_i,
    poll_period: ENV.fetch('GRPC_SERVER_POLL_PERIOD', 1).to_i
  }

  c.interceptors.use(Gruf::Interceptors::Instrumentation::RequestLogging::Interceptor, formatter: :logstash)

  if  ENV.fetch('GRPC_AUTH_TOKENS', 'austin').to_s.present?
    c.interceptors.use(
      Gruf::Interceptors::Authentication::Basic,
      credentials:  ENV.fetch('GRPC_AUTH_TOKENS', 'austin').to_s.split(',').map { |t| { password: t.strip } }
    )
  end
end
