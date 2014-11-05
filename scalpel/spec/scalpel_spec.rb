require 'spec_helper'
require 'scalpel'
require 'RMagick'

describe Scalpel do
  describe '#split_image' do
    it 'should return images of the same size' do
      original = Magick::Image.new 1000, 500 do
        self.format = 'PNG'
      end

      slices = Scalpel.split_image original, 10, 10

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

      slices = Scalpel.split_image original, 3, 3

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

      slices = Scalpel.split_image original, 10, 10

      slices.each do |slice|
        image = Magick::Image.from_blob(slice).first
        expect(image.format).to eq 'PNG'
      end
    end
  end
end