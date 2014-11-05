require 'gluegun/drawing_queue'
require 'gluegun/collector'
require 'gluegun/mosaic_maker'

module GlueGun
  class RequestHandler
    def initialize(connection)
      @connection = connection
    end

    def call(request, response)
      puts "Got request: #{request.inspect}"

      drawings = collect_drawings(request)

      puts 'Gluing drawings together'
      collage = glue_drawings request, drawings
      puts "Collage is #{collage}"

      response.ack
    end

    private

    def glue_drawings(request, drawings)
      GlueGun::MosaicMaker.new(request.col_count, request.row_count, request.width, request.height).call(drawings)
    end

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