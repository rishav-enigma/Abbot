class BaseService

  attr_accessor :connection, :channel
  # automatically_recover (boolean, default: true): when false, will disable automatic network failure recovery
  def initialize(hostname = 'rabbit.local', port = '15462', automatically_recover = false)
    @connection = Bunny.new(hostname: hostname, port: port, automatically_recover: automatically_recover)
  end

  def start
    @connection.start
  end

  def close
    @connection.close
  end

  def create_channel
    @channel = @new_connection.create_channel
  end

end