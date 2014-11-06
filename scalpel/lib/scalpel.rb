require 'scalpel/version'
require 'scalpel/order'
require 'boxes/split_image'
require 'boxes'

require 'RMagick'

module Scalpel
  def self.split_image(image, rows, columns)
    width = image.columns / columns
    height = image.rows / rows

    cols = (0...columns).to_a
    rows = (0...rows).to_a
    slices = rows.product(cols).map do |j, i|
      image.crop(i * width, j * height, width, height)
    end

    slices.map{ |slice| slice.to_blob{ self.format = 'PNG' } }
  end
end