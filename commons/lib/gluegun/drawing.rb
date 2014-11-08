require 'json'
require 'base64'

module GlueGun
  Drawing = Struct.new :id, :image do
    def self.from_json(json)
      hash = JSON.parse json

      image = hash['image'] ? Base64.decode64(hash['image']) : nil

      return new hash['id'], image
    end

    def to_json
      {id: id, image: base64_image}.to_json
    end

    private

    def base64_image
      Base64.encode64(image).strip if image
    end
  end
end