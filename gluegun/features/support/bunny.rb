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

  def queue_id
    @queue_id ||= SecureRandom.uuid
  end
end

World(BunnyHelper)

After do
  # clean up queues
  bunny.channel.queue_delete 'boxes.collages' rescue nil
  bunny.channel.queue_delete "boxes.drawings.#{queue_id}" rescue nil

  # close connections
  connection.close if connection && connection.open?
end