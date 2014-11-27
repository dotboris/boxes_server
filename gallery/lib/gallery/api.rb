require 'grape'
require 'gallery/drawing'

module Gallery
  class Api < Grape::API
    content_type :png, 'image/png'
    content_type :json, 'application/json'

    format :json
    get '/' do
      Gallery::Drawing.fields(:id).all.map &:id
    end

    format :png
    get '/:id' do
      drawing = Gallery::Drawing.find(params[:id])
      error! 'Not found', 404 unless drawing
      drawing.image
    end
  end
end