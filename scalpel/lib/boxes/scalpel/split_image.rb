require 'pathname'

module Boxes
  module Scalpel
    class SplitImage
      # create a new split image with a unique storage space
      # @param [Pathname] root directory to hold the new storage space
      def self.create!(root)
        root.mkpath
        dir = root + SecureRandom.uuid
        dir.mkdir
        new(dir)
      rescue
        # directory creation failed, try again
        retry
      end

      # @param [Pathname] dir directory used to store the split image
      def initialize(dir)
        @dir = dir
      end
    end
  end
end