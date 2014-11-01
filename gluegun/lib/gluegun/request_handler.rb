require 'gluegun/drawing_queue'
require 'gluegun/collector'

module GlueGun
  class RequestHandler
    def initialize(connection)
      @connection = connection
    end

    def call(request, response)
      puts "Got request: #{request.inspect}"

      collect_drawings(request)

      response.ack
    end

    private

    def collect_drawings(request)
      drawings_queue = GlueGun::DrawingQueue.new @connection, request.queue
      collector = GlueGun::Collector.new drawings_queue, request.row_count * request.col_count

      puts "Collecting drawings from #{request.queue}"
      drawings = collector.call
      puts "Finished collecting drawings. Got #{drawings.size} drawings, #{drawings.select(&:nil?).size} are nil"

      drawings
    end
  end
end