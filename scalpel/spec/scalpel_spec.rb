require 'spec_helper'
require 'boxes/scalpel'
require 'RMagick'

describe Boxes::Scalpel do
  describe '#split_image' do
    it 'should return images of the same size' do
      original = Magick::Image.new 1000, 500 do
        self.format = 'PNG'
      end

      slices = Boxes::Scalpel.split_image original.to_blob, 10, 10

      slices.each do |slice|
        image = Magick::Image.from_blob(slice).first
        expect(image.columns).to eq 100
        expect(image.rows).to eq 50
      end
    end

    it 'should handle odd image sizes' do
      original = Magick::Image.new 100, 100 do
        self.format = 'PNG'
      end

      slices = Boxes::Scalpel.split_image original.to_blob, 3, 3

      slices.each do |slice|
        image = Magick::Image.from_blob(slice).first
        expect(image.columns).to eq 33
        expect(image.rows).to eq 33
      end
    end

    it 'should convert slices to png' do
      original = Magick::Image.new 100, 100 do
        self.format = 'JPG'
      end

      slices = Boxes::Scalpel.split_image original.to_blob, 10, 10

      slices.each do |slice|
        image = Magick::Image.from_blob(slice).first
        expect(image.format).to eq 'PNG'
      end
    end
  end

  describe '#new_destination!' do
    include FakeFS::SpecHelpers

    it 'should create the root if it does not exist' do
      root = Pathname.new '/some/path/somewhere/maybe'

      Boxes::Scalpel.new_destination! root

      expect(root.exist?).to be_truthy
      expect(root.directory?).to be_truthy
    end

    it 'should create the directory returned' do
      destination = Boxes::Scalpel.new_destination! Pathname.new('/who/knows')

      expect(destination.exist?).to be_truthy
      expect(destination.directory?).to be_truthy
      expect(destination.to_s).to start_with('/who/knows/')
    end

    it 'should retry until it can create a directory' do
      allow(SecureRandom).to receive(:uuid).and_return('a', 'b')
      root = Pathname.new '/who/knows'
      (root + 'a').mkpath

      destination = Boxes::Scalpel.new_destination! root

      expect(destination).to eq(root + 'b')
    end
  end
end