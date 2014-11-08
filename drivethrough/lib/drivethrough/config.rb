require 'jerry'
require 'drivethrough/queue'
require 'gluegun/drawing_queue'

class DriveThrough
  class Config < Jerry::Config
    component :bunny do
      conn = Boxes.bunny
      conn.start
      conn
    end

    component :slices_queue do
      channel = rig(:bunny).channel
      channel.prefetch 1
      queue = channel.queue('boxes.slices')
      DriveThrough::Queue.new queue
    end

    component :slices_load_queue do
      rig(:bunny).channel.queue('boxes.slices.load')
    end

    component :drivethrough do
      DriveThrough.new rig(:slices_queue), rig(:slices_load_queue)
    end
  end
end