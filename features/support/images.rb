require 'RMagick'

module ImageHelper
  def load_image(name)
    File.read image_path(name)
  end

  def as_png(blob)
    image = Magick::Image.from_blob blob do
      self.depth = 8
    end.first
    image.format = 'PNG'

    image
  end
end

World(ImageHelper)