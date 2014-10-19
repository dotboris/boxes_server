require 'bunny'
require 'delegate'

class DriveThrough
  # wrapper for a bunny queue
  class Queue < Delegator
    class Timeout < StandardError; end

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

      raise Timeout, 'Could not get a message in time'
    end
  end
end