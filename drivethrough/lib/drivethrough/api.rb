require 'grape'
require 'jerry'
require 'drivethrough'
require 'drivethrough/config'
require 'drivethrough/queue'
require 'gluegun/drawing'
require 'gluegun/drawing_queue'

class DriveThrough
  class Api < Grape::API
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
      content_type :binary, 'application/json'
      format :binary

      desc 'Return a random image slice.'
      get do
        header 'Cache-Control', 'no-cache'

        dt.slice
      end
    end

    resource :drawings do
      content_type :binary, 'image/png'
      format :binary

      desc 'Push drawings to system'
      put ':queue/:id' do
        queue = GlueGun::DrawingQueue.new bunny, params[:queue]
        drawing = GlueGun::Drawing.new params[:id].to_i, env['api.request.input']
        queue.publish drawing
      end
    end
  end
end