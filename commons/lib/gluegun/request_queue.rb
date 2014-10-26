require 'gluegun/request'

module Gluegun
  class RequestQueue
    class Response
      def initialize(channel, tag)
        @channel = channel
        @tag = tag
      end

      def ack
        @channel.ack(@tag)
      end

      def nack
        @channel.nack(@tag)
      end
    end

    def initialize(connection)
      @channel = connection.channel
      @queue = @channel.queue('boxes.collages')
    end

    def subscribe(&block)
      @queue.subscribe block: true, manual_ack: true do |delivery_info, _, payload|
        request = Gluegun::Request.from_json payload
        response = Response.new @channel, delivery_info.delivery_tag

        block.call request, response
      end
    end
  end
end