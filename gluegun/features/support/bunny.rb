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

  def poll_queue(name, timeout)
    res = []

    queue = bunny.channel.queue(name)

    (timeout * 2).times do
      res = queue.pop

      break unless res.any? &:nil?

      sleep 0.5
    end

    raise "Queue poll for #{name} timed out" if res.any? &:nil?

    res
  end

  def drop_all_queues!
    bunny.channel.queue_delete 'boxes.collages' rescue nil
    bunny.channel.queue_delete 'boxes.collages.ingest' rescue nil
    bunny.channel.queue_delete "boxes.drawings.#{queue_id}" rescue nil
  end
end

World(BunnyHelper)

After do
  drop_all_queues!

  connection.close if connection && connection.open?
end