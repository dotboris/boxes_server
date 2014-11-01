require 'boxes/queue_response'
require 'gluegun/request'

module Gluegun
  class RequestQueue
    def initialize(connection)
      @channel = connection.channel
      @channel.prefetch(1)
      @queue = @channel.queue('boxes.collages')
    end

    def subscribe(&block)
      @queue.subscribe block: true, manual_ack: true, durable: true do |delivery_info, _, payload|
        request = Gluegun::Request.from_json payload
        response = Boxes::QueueResponse.new @channel, delivery_info.delivery_tag

        block.call request, response
      end
    end
  end
end