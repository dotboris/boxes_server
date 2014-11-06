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

    it 'should cut images left to right' do
      draw = Magick::Draw.new.
          fill('red').point(0, 0).
          fill('green').point(1, 0).
          fill('blue').point(2, 0).
          fill('purple').point(0, 1).
          fill('yellow').point(1, 1).
          fill('pink').point(2, 1)
      image = Magick::Image.new 3, 2
      draw.draw(image)

      slices = Scalpel.split_image image, 2, 3

      expected_colors = %w{red green blue purple yellow pink}
      actual_colors = slices.
          map { |slice| Magick::Image.from_blob(slice).first }.
          map { |slice| slice.pixel_color(0, 0).to_color }

      expect(actual_colors).to eq expected_colors
    end
  end
end