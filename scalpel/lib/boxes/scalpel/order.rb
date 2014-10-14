require 'json'
require 'base64'

module Boxes
  module Scalpel
    Order = Struct.new :image, :x, :y do
      def self.from_json(json)
        hash = JSON.parse json
        new Base64.decode64(hash['image']), hash['x'], hash['y']
      end
    end
  end
end