require 'gluegun/drawing'

module Gluegun
  class Collector
    TIMEOUT = 300

    def initialize(queue, target)
      @queue = queue
      @target = target
    end

    def call
      drawings = Array.new @target
      count = 0

      TIMEOUT.times do
        delivery_info, _, payload = @queue.pop

        if payload
          drawing = Drawing.from_json payload

          if drawings[drawing.id]
            @queue.channel.ack(delivery_info.delivery_tag, false)
          else
            drawings[drawing.id] = drawing.image
            count += 1
          end
        end

        break if count == @target

        sleep 1
      end

      drawings
    end
  end
end