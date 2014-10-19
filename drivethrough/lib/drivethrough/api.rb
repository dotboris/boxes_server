require 'grape'
require 'drivethrough'
require 'drivethrough/queue'

class DriveThrough
  class Api < Grape::API
    format :json

    helpers do
      def dt
        @dt ||= DriveThrough.create!
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
  end
end