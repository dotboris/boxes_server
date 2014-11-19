require 'mongo_mapper'

module Gallery
  class Drawing
    include MongoMapper::Document

    key :image, Binary
  end
end