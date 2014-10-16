require 'spec_helper'
require 'forklift'

describe Forklift do
  describe '#load_slices' do
    before do
      # load_slices is noisy, silence stdout
      allow($stdout).to receive(:write)
    end

    it 'should pick a random sliced image' do
      media_root = double('media root')
      forklift = Forklift.new media_root, double('slices queue')

      expect(Boxes::SplitImage).to receive(:pick_active).with(media_root).
                                       and_return(double('sliced image').as_null_object)

      forklift.load_slices
    end

    it 'should publish all slices' do
      split_image = double('split image', slices: %w{echo foxtrot golf hotel})
      allow(Boxes::SplitImage).to receive(:pick_active).and_return(split_image)
      slices_queue = double('slices queue')
      forklift = Forklift.new double('media root'), slices_queue

      expect(slices_queue).to receive(:publish).with('echo')
      expect(slices_queue).to receive(:publish).with('foxtrot')
      expect(slices_queue).to receive(:publish).with('golf')
      expect(slices_queue).to receive(:publish).with('hotel')

      forklift.load_slices
    end
  end
end