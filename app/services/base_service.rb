class BaseService

  attr_accessor :connection, :channel
  # automatically_recover (boolean, default: true): when false, will disable automatic network failure recovery
  def initialize(automatically_recover = false)
    @connection = Bunny.new(automatically_recover: automatically_recover)
  end

  def start
    @connection.start
  end

  def close
    @connection.close
  end

  def create_channel
    @channel = @connection.create_channel
  end

end