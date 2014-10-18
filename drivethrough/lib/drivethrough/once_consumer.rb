require 'bunny'
require 'thread'

class DriveThrough
  class OnceConsumer < Bunny::Consumer
    class TimeoutError < StandardError; end

    def initialize(channel, queue, consumer_tag = channel.generate_consumer_tag, exclusive = false, arguments = {})
      super(channel, queue, consumer_tag, false, exclusive, arguments)

      @value = nil
      @value_mutex = Mutex.new
      @value_cond = ConditionVariable.new

      @deliver_mutex = Mutex.new

      @canceled = false
    end

    def value(timeout = nil)
      @value_mutex.synchronize { @value_cond.wait @value_mutex, timeout }

      @deliver_mutex.synchronize do
        if @value
          @value
        else
          raise TimeoutError, 'Did not get a message in time'
        end
      end
    end

    def call(delivery_info, properties, payload)
      return if @canceled

      @deliver_mutex.synchronize do

        unless @value
          @value = [delivery_info, properties, payload]

          # only ack the value we got
          @channel.ack(delivery_info.delivery_tag, false)

          @value_cond.signal
        end

        # we got what we came for, requeue everything else
        @channel.nack(delivery_info.delivery_tag, true, true)
      end

      # avoid receiving any other messages
      @canceled = true
      cancel # will kill the thread if we're the only consumer
    end
  end
end