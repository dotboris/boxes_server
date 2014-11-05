require 'spec_helper'
require 'gluegun/mosaic_maker'


def color_blob(color, w, h)
  Magick::Image.new w, h do
    self.format = 'PNG'
    self.depth = 8
    self.background_color = color
  end.to_blob
end

describe GlueGun::MosaicMaker do
  it 'should create a png' do
    maker = GlueGun::MosaicMaker.new 2, 2, 100, 100
    image = maker.call [color_blob('hotpink', 100, 100)] * 4

    expect(image.format).to eq 'PNG'
  end

  it 'should create an image with the right resulting size' do
    maker = GlueGun::MosaicMaker.new 2, 3, 50, 100

    image = maker.call Array.new(6)

    expect(image.rows).to eq 300
    expect(image.columns).to eq 100
  end

  it 'should add images left to right' do
    blobs = %w{red green blue yellow purple pink}.map do |color|
      color_blob(color, 1, 1)
    end
    maker = GlueGun::MosaicMaker.new 2, 3, 1, 1

    mosaic = maker.call blobs

    expect(mosaic.pixel_color 0, 0).to eq Magick::Pixel.from_color('red')
    expect(mosaic.pixel_color 0, 1).to eq Magick::Pixel.from_color('green')
    expect(mosaic.pixel_color 0, 2).to eq Magick::Pixel.from_color('blue')
    expect(mosaic.pixel_color 1, 0).to eq Magick::Pixel.from_color('yellow')
    expect(mosaic.pixel_color 1, 1).to eq Magick::Pixel.from_color('purple')
    expect(mosaic.pixel_color 1, 2).to eq Magick::Pixel.from_color('pink')
  end


  it 'should leave nil images blank' do
    blobs = [color_blob('hotpink', 1, 1), nil]
    maker = GlueGun::MosaicMaker.new 2, 1, 1, 1

    mosaic = maker.call blobs

    expect(mosaic.pixel_color 0, 0).to eq Magick::Pixel.from_color('hotpink')
    expect(mosaic.pixel_color 1, 0).to eq Magick::Pixel.from_color('white')
  end
end