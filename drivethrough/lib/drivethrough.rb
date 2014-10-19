require 'drivethrough/version'
require 'drivethrough/api'
require 'drivethrough/queue'
require 'boxes'
require 'thread'

class DriveThrough
  class NoSlicesError < StandardError; end

  def self.create!
    connection = Boxes.bunny
    connection.start
    channel = connection.create_channel
    channel.prefetch 1

    slices_queue = DriveThrough::Queue.new(channel.queue('boxes.slices'))
    new(slices_queue, channel.queue('boxes.slices.load'))
  end

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