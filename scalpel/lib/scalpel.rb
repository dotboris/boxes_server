require 'scalpel/version'
require 'scalpel/order'
require 'boxes/split_image'
require 'boxes'

require 'RMagick'

module Scalpel
  def self.split_image(image, rows, columns)
    width = image.columns / columns
    height = image.rows / rows

    slices = (0...columns).to_a.product((0...rows).to_a).map do |i, j|
      image.crop(i * width, j * height, width, height)
    end

    slices.map{ |slice| slice.to_blob{ self.format = 'PNG' } }
  end
end