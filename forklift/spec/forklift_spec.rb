require 'spec_helper'
require 'forklift'

describe Forklift do
  describe '#load_slices' do
    before do
      # load_slices is noisy, silence stdout
      allow($stdout).to receive(:write)
    end

    let(:media_root) { double 'media root' }
    let(:slices_queue) { double 'slices queue' }
    let(:request_queue) { double 'request queue' }
    let(:forklift) { Forklift.new media_root, slices_queue, request_queue }

    let(:original) { double 'original image' }
    let(:split_image) do
      double 'split image',
             slices: ['thing'],
             row_count: 1,
             width: 100,
             height: 100
    end

    before do
      allow(Boxes::SplitImage).to receive(:pick_active).and_return split_image
      allow(slices_queue).to receive(:publish)
      allow(request_queue).to receive(:publish)
    end

    it 'should pick a random sliced image' do
      expect(Boxes::SplitImage).to receive(:pick_active).with(media_root)

      forklift.load_slices
    end

    it 'should publish all slices' do
      allow(SecureRandom).to receive(:uuid).and_return('some_queue')
      allow(split_image).to receive(:slices).and_return %w{echo foxtrot golf hotel}

      expect(slices_queue).to receive(:publish).with Forklift::Slice.new('some_queue', 0, 'echo').to_json
      expect(slices_queue).to receive(:publish).with Forklift::Slice.new('some_queue', 1, 'foxtrot').to_json
      expect(slices_queue).to receive(:publish).with Forklift::Slice.new('some_queue', 2, 'golf').to_json
      expect(slices_queue).to receive(:publish).with Forklift::Slice.new('some_queue', 3, 'hotel').to_json

      forklift.load_slices
    end

    it 'should create a collage request' do
      allow(split_image).to receive(:slices).and_return Array.new(18)
      allow(split_image).to receive(:row_count).and_return 6
      allow(split_image).to receive(:width).and_return 900
      allow(split_image).to receive(:height).and_return 100

      expect(request_queue).to receive(:publish) do |request|
        expect(request.queue).not_to be_nil
        expect(request.row_count).to eq 6
        expect(request.col_count).to eq 3
        expect(request.width).to eq 900
        expect(request.height).to eq 100
      end

      forklift.load_slices
    end
  end
end