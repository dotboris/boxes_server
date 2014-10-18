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

    def pop_waiting(timeout)
      done = false
      received_message = false
      race_mutex = Mutex.new

      pop_mutex = Mutex.new
      next_value = ConditionVariable.new

      pop_mutex.synchronize do
        ret = nil
        consumer = Bunny::Consumer.new @queue.channel, @queue, '', false
        consumer.on_delivery do |delivery_info, _, body|
          race_mutex.synchronize do
            unless received_message
              # only run once
              received_message = true
              consumer.cancel

              if done
                @queue.channel.nack(delivery_info.delivery_tag, true, true)
              else
                ret = body
                done = true
                @queue.channel.acknowledge(delivery_info.delivery_tag, false)
                next_value.signal
              end
              @queue.channel.nack(delivery_info.delivery_tag, true, true)
            end
          end
        end

        @queue.subscribe_with consumer, manual_ack: true

        next_value.wait pop_mutex, timeout
        race_mutex.synchronize do
          if done
            ret
          else
            done = true
            raise TimeoutError
          end
        end
      end
    end
  end
end