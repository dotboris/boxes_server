require 'drivethrough/version'
require 'drivethrough/api'

class DriveThrough
  class NoSlicesError < StandardError; end

  def initialize(slices_queue, request_queue)
    @slices_queue = slices_queue
    @request_queue = request_queue
  end

  def slice
    _, _, body = @slices_queue.pop

    if body
      body
    else
      request_more_slices
      requested_slice
    end
  end

  private

  def request_more_slices
    @request_queue.publish
  end

  def requested_slice
    res = @slices_queue.subscribe(timeout: 5) { |_, _, body| body }
    raise NoSlicesError, 'Could not find any slices' if res == :timed_out
    res
  end
end