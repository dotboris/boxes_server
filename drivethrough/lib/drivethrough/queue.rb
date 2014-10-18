require 'drivethrough/once_consumer'
require 'bunny'

class DriveThrough
  # wrapper for a bunny queue
  class Queue < Delegator
    class TimeoutError < StandardError; end

    def initialize(queue)
      super
      @queue = queue
    end

    def __getobj__
      @queue
    end

    def __setobj__(obj)
      @queue = obj
    end

    def pop_waiting(timeout = nil)
      consumer = OnceConsumer.new @queue.channel, @queue
      @queue.subscribe_with(consumer, block: false)

      consumer.value(timeout)
    end
  end
end