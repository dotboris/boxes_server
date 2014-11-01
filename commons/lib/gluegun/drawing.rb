require 'json'
require 'base64'

module GlueGun
  Drawing = Struct.new :id, :image do
    def self.from_json(json)
      hash = JSON.parse json

      image = hash['image'] ? Base64.decode64(hash['image']) : nil

      return new hash['id'], image
    end
  end
end