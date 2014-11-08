require 'gluegun/drawing'

module GlueGun
  class Collector
    TIMEOUT = 300

    def initialize(queue, target)
      @queue = queue
      @target = target
    end

    def call
      responses = []
      drawings = Array.new @target
      count = 0

      TIMEOUT.times do
        drawing, response = @queue.pop

        if drawing
          if drawings[drawing.id]
            response.ack
          else
            drawings[drawing.id] = drawing.image
            responses << response
            count += 1
          end
        end

        break if count == @target

        sleep 1
      end

      ack_callback = proc { responses.each &:ack }

      [drawings, ack_callback]
    end
  end
end