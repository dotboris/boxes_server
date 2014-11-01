require 'gluegun/drawing'

module Gluegun
  class Collector
    TIMEOUT = 300

    def initialize(queue, target)
      @queue = queue
      @target = target
    end

    def call
      tags = []
      drawings = Array.new @target
      count = 0

      TIMEOUT.times do
        delivery_info, _, payload = @queue.pop

        if payload
          drawing = Drawing.from_json payload

          if drawings[drawing.id]
            @queue.ack(delivery_info.delivery_tag)
          else
            drawings[drawing.id] = drawing.image
            tags << delivery_info.delivery_tag
            count += 1
          end
        end

        break if count == @target

        sleep 1
      end

      tags.each { |tag| @queue.ack tag }

      drawings
    end
  end
end