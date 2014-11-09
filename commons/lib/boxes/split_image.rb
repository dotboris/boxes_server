require 'pathname'
require 'securerandom'

module Boxes
  class SplitImage
    class SplitImageNotFound < StandardError; end

    # create a new split image with a unique storage space
    # @param [Pathname] root directory to hold the new storage space
    def self.create!(root)
      root.mkpath
      dir = root + SecureRandom.uuid
      dir.mkdir
      new(dir)
    rescue => e
      # directory creation failed, try again
      puts "Failed to create #{dir}"
      puts e.message
      puts e.backtrace
      retry
    end

    # read a split image from the disk
    # @param [Pathname] path directory containing the split image
    def self.read(path)
      split_image = new(path)
      split_image.row_count = (path + 'row_count').open(&:read).to_i
      split_image.width = (path + 'width').open(&:read).to_i
      split_image.height = (path + 'height').open(&:read).to_i
      split_image.original = (path + 'original.png').open &:read

      # we need to sort the files by name manually because we can't trust the FS
      slices = path.children.select { |p| /^\d+\.png/ =~ p.basename.to_s }
      slices.sort_by! { |p| p.basename.to_s.scan(/^\d+/).first.to_i }
      split_image.slices = slices.map { |p| p.open &:read }

      split_image
    end

    # pick a random active split image and read it
    def self.pick_active(root)
      candidates = root.children.select { |path| (path+'active').exist? } rescue []

      raise SplitImageNotFound, 'found no active split images' if candidates.empty?

      read(candidates.sample)
    end

    attr_accessor :original, :slices, :row_count, :width, :height

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
      (@dir + 'width').open('w') { |f| f.write width }
      (@dir + 'height').open('w') { |f| f.write height }

      slices.each.with_index do |slice, i|
        (@dir + "#{i}.png").open('w') { |f| f.write slice }
      end
    end

    def activate!
      (@dir + 'active').open('w') {}
    end

    def inspect
      "<#{self.class}: dir=#{@dir} row_count=#{row_count} slices.size=#{slices.size}>"
    end
  end
end