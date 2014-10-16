require 'forklift/version'
require 'boxes/split_image'

class Forklift
  def initialize(media_root, slices_queue)
    @media_root = media_root
    @slices_queue = slices_queue
  end

  def load_slices
    split_image = Boxes::SplitImage.pick_active @media_root
  end
end