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
  end
end