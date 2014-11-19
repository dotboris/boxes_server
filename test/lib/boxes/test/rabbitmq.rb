require 'bunny'

module Boxes
  module Test
    module RabbitMq
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

      def drop_queue(queue)
        bunny_channel.queue_delete queue rescue nil
      end
    end
  end
end