require 'spec_helper'
require 'forklift'

describe Forklift do
  describe '#load_slices' do
    it 'should pick a random sliced image' do
      media_root = double('media root')
      forklift = Forklift.new media_root, media_root

      expect(Boxes::SplitImage).to receive(:pick_active)

      forklift.load_slices
    end
  end
end