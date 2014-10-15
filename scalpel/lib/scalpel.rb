require 'scalpel/version'
require 'scalpel/order'
require 'scalpel/split_image'
require 'boxes/commons'

require 'RMagick'

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
end