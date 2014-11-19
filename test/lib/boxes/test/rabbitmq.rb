require 'bunny'

module Boxes
  module Test
    module RabbitMq
      QUEUES = %w{
        boxes.collages
        boxes.collages.ingest
        boxes.slices
        boxes.slices.load
        boxes.uncut
      }

      def bunny
        unless @bunny
          @bunny = Bunny.new amqp_url
          @bunny.start
        end

        @bunny
      end

      def drawing_queue_id
        @drawing_queue_id ||= SecureRandom.uuid
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

      def drop_all_queues!
        QUEUES.each { |queue| drop_queue queue }
        drop_queue "boxes.drawings.#{drawing_queue_id}"
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
    end
  end
end