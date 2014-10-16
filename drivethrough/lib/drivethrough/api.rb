require 'grape'

module DriveThrough
  class Api < Grape::API
    format :json

    resource :slices do
      desc 'Return a random image slice.'
      get do
        'who knows'
      end
    end
  end
end