require 'RMagick'

module GlueGun
  class MosaicMaker
    def initialize(cols, rows, image_width, image_height)
      @cols = cols
      @rows = rows
      @width = image_width
      @height = image_height
    end

    def call(blobs)
      rows = (0...@rows).to_a
      cols = (0...@cols).to_a

      images = cols.product(rows).zip(blobs).map do |(x, y), blob|
        create_image x, y, blob
      end

      list = images.reduce(Magick::ImageList.new) { |list, image| list << image }

      list.mosaic do
        self.format = 'PNG'
      end
    end

    private

    def from_blob_or_bank(blob)
      if blob
        Magick::Image.from_blob(blob).first
      else
        Magick::Image.new @width, @height do
          self.format = 'PNG'
        end
      end
    end

    def create_image(x, y, blob)
      image = from_blob_or_bank(blob)

      image.resize! @width, @height
      image.page = Magick::Rectangle.new(@width, @height, x * @width, y * @height)

      image
    end
  end
end