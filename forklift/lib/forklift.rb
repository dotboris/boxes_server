require 'forklift/version'
require 'boxes/split_image'
require 'gluegun/request'

class Forklift
  def initialize(media_root, slices_queue, request_queue)
    @media_root = media_root
    @slices_queue = slices_queue
    @request_queue = request_queue
  end

  def load_slices
    split_image = Boxes::SplitImage.pick_active @media_root
    puts "the winner is (drum roll)... #{split_image.inspect}"

    request = GlueGun::Request.new SecureRandom.uuid,
                                   split_image.row_count,
                                   split_image.slices.size / split_image.row_count,
                                   split_image.width,
                                   split_image.height
    @request_queue.publish request
    puts 'Sent a collage request'

    split_image.slices.each { |slice| @slices_queue.publish slice }

    puts 'Published slices'
  end
end