require 'bunny'

module Clerk
  class CollageQueue
    def initialize(connection)
      @channel = connection.channel
      @queue = @channel.queue 'boxes.collages.ingest'
    end

    def publish(stuff)
      @queue.publish stuff
    end

    def subscribe(&block)
      @queue.subscribe block: true do |_, _, payload|
        block.call payload
      end
    end
  end
end