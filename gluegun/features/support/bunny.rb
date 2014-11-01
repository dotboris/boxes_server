module BunnyHelper
  def amqp_url
    ENV['BOXES_AMQP_URL'] || 'amqp://boxes:boxes@localhost'
  end

  attr_reader :connection

  def bunny
    unless @connection
      @connection = Bunny.new amqp_url
      @connection.start
    end

    @connection
  end
end

World(BunnyHelper)

After do
  connection.close if connection && connection.open?
end