require 'boxes/queue_response'
require 'gluegun/drawing'

module GlueGun
  class DrawingQueue
    def initialize(connection, id)
      @channel = connection.channel
      @queue = @channel.queue "boxes.drawings.#{id}"
    end

    def publish(drawing)
      @queue.publish drawing.to_json
    end

    def pop
      delivery_info, _, payload = @queue.pop manual_ack: true

      if payload
        response = Boxes::QueueResponse.new @channel, delivery_info.delivery_tag
        drawing = GlueGun::Drawing.from_json payload

        [drawing, response]
      else
        [nil, nil]
      end
    end

    def delete
      @queue.delete
    end
  end
end