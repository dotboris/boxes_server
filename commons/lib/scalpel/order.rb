require 'json'
require 'base64'

module Scalpel
  Order = Struct.new :image, :columns, :rows do
    def self.from_json(json)
      hash = JSON.parse json
      new Base64.decode64(hash['image']), hash['columns'], hash['rows']
    end

    def to_json
      hash = {
          columns: columns, rows: rows,
          image: Base64.encode64(image).chomp
      }

      hash.to_json
    end
  end
end