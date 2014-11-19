require 'mongo_mapper'

module Boxes
  # noinspection RubyStringKeysInHashInspection
  def self.configure_mongo_mapper
    url = ENV['BOXES_MONGODB_URL'] || 'mongodb://localhost/boxes'
    MongoMapper.setup({'production' => {'uri' => url}}, 'production')
  end
end