require 'bunny'

module BunnyHelpers
  def bunny
    unless @bunny
      @bunny = Bunny.new amqp_url
      @bunny.start
    end

    @bunny
  end

  def bunny_channel
    @channel ||= bunny.create_channel
  end

  def bunny_disconnect
    @bunny.close if @bunny
  end

  def purge_slices
    bunny_channel.queue_purge 'boxes.slices'
  end

  def purge_slices_requests
    bunny_channel.queue_purge 'boxes.slices.load'
  end

  def purge_uncut_images
    bunny_channel.queue_purge 'boxes.uncut'
  end
end

Before do
  purge_uncut_images
  purge_slices_requests
  purge_slices
end

After do
  bunny_disconnect
end

World(BunnyHelpers)