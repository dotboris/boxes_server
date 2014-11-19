require 'mongo'

module Boxes
  module Test
    module MongoDb
      def drawings_collection
        Mongo::MongoClient.from_uri(mongodb_url).db.collection('gallery.drawings')
      end

      def clear_drawings_collection!
        drawings_collection.remove
      end
    end
  end
end