require 'grape'
require 'jerry'
require 'drivethrough'
require 'drivethrough/config'
require 'drivethrough/queue'
require 'gluegun/drawing'
require 'gluegun/drawing_queue'

class DriveThrough
  class Api < Grape::API
    format :json

    helpers do
      def bunny
        jerry.rig :bunny
      end

      def jerry
        @jerry ||= Jerry.new DriveThrough::Config.new
      end

      def dt
        jerry.rig(:drivethrough)
      end
    end

    rescue_from DriveThrough::Queue::Timeout do |e|
      Rack::Response.new([e.message], 408, 'Content-Type' => 'text/error').finish
    end

    resource :slice do
      desc 'Return a random image slice.'
      get do
        env['api.format'] = :binary
        header 'Cache-Control', 'no-cache'
        header 'Content-Type', 'image/png'

        dt.slice
      end
    end

    resource :drawings do
      content_type :png, 'image/png'
      format :png

      desc 'Push drawings to system'
      put ':queue/:id' do
        queue = GlueGun::DrawingQueue.new bunny, params[:queue]
        drawing = GlueGun::Drawing.new params[:id].to_i, env['api.request.input']
        queue.publish drawing
      end
    end
  end
end