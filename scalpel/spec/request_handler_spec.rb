require 'spec_helper'
require 'scalpel/request_handler'
require 'scalpel/order'

describe Scalpel::RequestHandler do
  before do
    allow($stdout).to receive(:write)
  end

  let(:media_root) { Pathname.new '/some/place' }
  let(:handler) { Scalpel::RequestHandler.new media_root }

  let(:image) { Magick::Image.new(100, 100).to_blob { self.format = 'PNG' } }
  let(:order) { Scalpel::Order.new image, 6, 2 }
  let(:split_image) { double 'split image' }

  before do
    allow(split_image).to receive(:slices=)
    allow(split_image).to receive(:original=)
    allow(split_image).to receive(:row_count=)
    allow(split_image).to receive(:width=)
    allow(split_image).to receive(:height=)
    allow(split_image).to receive(:save!)
    allow(split_image).to receive(:activate!)

    allow(Boxes::SplitImage).to receive(:create!).and_return split_image
    allow(Scalpel).to receive(:split_image).and_return []
  end

  it 'should create a split image' do
    handler = Scalpel::RequestHandler.new Pathname.new('/media/root')
    image = Magick::Image.new(100, 200).to_blob { self.format = 'PNG' }
    order = Scalpel::Order.new image, 3, 2
    allow(Scalpel).to receive(:split_image).and_return %w{a b c d e f}

    expect(Boxes::SplitImage).to receive(:create!).with Pathname.new('/media/root')

    expect(split_image).to receive(:slices=).with %w{a b c d e f}
    expect(split_image).to receive(:original=).with image
    expect(split_image).to receive(:row_count=).with 3
    expect(split_image).to receive(:width=).with 100
    expect(split_image).to receive(:height=).with 200

    handler.call order
  end

  it 'should save and activate the split image' do
    expect(split_image).to receive(:save!).ordered
    expect(split_image).to receive(:activate!).ordered

    handler.call order
  end

  it 'should split images' do
    image = Magick::Image.new(200, 200) do
      self.format = 'PNG'
      self.depth = 8
    end

    order = Scalpel::Order.new image.to_blob, 1, 4

    expect(Scalpel).to receive(:split_image).with(image, 1, 4)

    handler.call order
  end
end