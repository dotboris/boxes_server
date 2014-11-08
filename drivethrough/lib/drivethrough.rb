require 'drivethrough/version'
require 'drivethrough/queue'
require 'boxes'
require 'thread'

class DriveThrough
  def initialize(slices_queue, request_queue)
    @slices_queue = slices_queue
    @request_queue = request_queue
  end

  def slice
    _, _, payload = @slices_queue.pop

    if payload
      payload
    else
      request_more_slices
      _, _, payload = requested_slice
      payload
    end
  end

  private

  def request_more_slices
    @request_queue.publish ''
  end

  def requested_slice
    @slices_queue.pop_waiting 2
  end
end