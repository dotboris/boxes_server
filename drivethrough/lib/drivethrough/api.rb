require 'grape'

class DriveThrough
  class Api < Grape::API
    format :json

    resource :slice do
      desc 'Return a random image slice.'
      get do
        'who knows'
      end
    end
  end
end