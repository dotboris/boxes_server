module Boxes
  class QueueResponse
    def initialize(channel, tag)
      @channel = channel
      @tag = tag
    end

    def ack
      @channel.ack(@tag, false)
    end

    def nack
      @channel.nack(@tag, false, true)
    end
  end
end