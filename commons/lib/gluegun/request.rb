require 'json'

module GlueGun
  Request = Struct.new(:queue, :row_count, :width, :height) do
    def self.from_json(json)
      hash = JSON.parse json
      return new(hash['queue'], hash['row_count'], hash['width'], hash['height'])
    end
  end
end