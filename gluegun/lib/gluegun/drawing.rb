require 'json'
require 'RMagick'
require 'base64'

module Gluegun
  Drawing = Struct.new :id, :image do
    def self.from_json(json)
      hash = JSON.parse json

      image = Magick::Image.from_blob(Base64.decode64(hash['image'])).first rescue nil

      return new hash['id'], image
    end
  end
end