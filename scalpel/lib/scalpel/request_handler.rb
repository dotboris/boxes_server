module Scalpel
  class RequestHandler
    def initialize(media_root)
      @root = media_root
    end

    def call(order)
      original = Magick::Image.from_blob(order.image).first
      slices = Scalpel.split_image original, order.rows, order.columns

      split_image = Boxes::SplitImage.create! @root
      split_image.slices = slices
      split_image.original = order.image
      split_image.row_count = order.rows
      split_image.width = original.columns
      split_image.height = original.rows

      puts "split image: #{split_image.inspect}"

      split_image.save!
      puts 'Saved split image'

      split_image.activate!
      puts 'Activated split image'
    end
  end
end