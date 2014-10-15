require 'boxes/scalpel/version'
require 'boxes/scalpel/order'
require 'boxes/commons'

require 'RMagick'

module Boxes
  module Scalpel
    def self.split_image(image, x, y)
      base_image = Magick::Image.from_blob(image).first

      width = base_image.columns / x
      height = base_image.rows / y

      slices = (0...x).zip(0...y).map do |i, j|
        base_image.crop(i * width, j * height, width, height)
      end

      slices.map{ |slice| slice.to_blob{ self.format = 'PNG' } }
    end

    def self.new_destination!(root)
      root.mkpath
      destination = root + SecureRandom.uuid
      destination.mkdir
      destination
    rescue
      # directory creation failed, try again
      retry
    end
  end
end