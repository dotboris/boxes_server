require 'json'
require 'base64'

module Scalpel
  Order = Struct.new :image, :rows, :columns do
    def self.from_json(json)
      hash = JSON.parse json
      new Base64.decode64(hash['image']), hash['rows'], hash['columns']
    end

    def to_json
      hash = {
          columns: columns, rows: rows,
          image: Base64.encode64(image).chomp
      }

      hash.to_json
    end

    def inspect
      "<#{self.class.name}: rows=#{rows} columns=#{columns} image.size=#{image.size}>"
    end
  end
end