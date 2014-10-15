require 'pathname'

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

    attr_accessor :original, :slices, :row_count

    # @param [Pathname] dir directory used to store the split image
    def initialize(dir)
      @dir = dir
      @original = nil
      @slices = []
      @row_count = 1
    end

    def save!
      (@dir + 'original.png').open('w') { |f| f.write original }
      (@dir + 'row_count').open('w') { |f| f.write row_count }

      slices.each.with_index do |slice, i|
        (@dir + "#{i}.png").open('w') { |f| f.write slice }
      end
    end

    def activate!
      (@dir + 'active').open('w') {}
    end
  end
end