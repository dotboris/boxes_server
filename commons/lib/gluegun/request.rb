require 'json'

module Gluegun
  Request = Struct.new(:queue, :row_count) do
    def self.from_json(json)
      hash = JSON.parse json
      return new(hash['queue'], hash['row_count'])
    end
  end
end