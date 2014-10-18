require 'grape'
require 'drivethrough'

class DriveThrough
  class Api < Grape::API
    format :json

    helpers do
      def dt
        @dt ||= DriveThrough.create!
      end
    end

    resource :slice do
      desc 'Return a random image slice.'
      get do
        env['api.format'] = :binary
        content_type 'image/png'

        dt.slice
      end
    end
  end
end