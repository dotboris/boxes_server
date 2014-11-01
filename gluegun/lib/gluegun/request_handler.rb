require 'gluegun/drawing_queue'
require 'gluegun/collector'

module GlueGun
  class RequestHandler
    def initialize(connection)
      @connection = connection
    end

    def call(request, response)
      puts "Got request: #{request.inspect}"

      drawings_queue = GlueGun::DrawingQueue.new @connection, request.queue
      collector = GlueGun::Collector.new drawings_queue, request.row_count * request.col_count

      puts "Collecting drawings from #{request.queue}"
      drawings = collector.call
      puts "Finished collecting drawings. Got #{drawings.size} drawings, #{drawings.select(&:nil?).size} are nil"

      response.ack
    end
  end
end