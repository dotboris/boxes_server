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
      (timeout * 2).times do
        res = @queue.pop
        return res unless res.any? &:nil?
        sleep 0.5
      end

      raise TimeoutError, 'Could not get a message in time'
    end
  end
end