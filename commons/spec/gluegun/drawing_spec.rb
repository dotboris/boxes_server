require 'spec_helper'
require 'gluegun/drawing'
require 'base64'

describe GlueGun::Drawing do
  let(:drawing) { GlueGun::Drawing.new 'a special snowflake', 'baby photos' }

  it 'should have an id' do
    expect(drawing).to respond_to :id, :id=
    expect(drawing.id).to eq 'a special snowflake'
  end

  it 'should have an image' do
    expect(drawing).to respond_to :image, :image=
    expect(drawing.image).to eq 'baby photos'
  end

  describe '#from_json' do
    it 'should return a drawing' do
      expect(GlueGun::Drawing.from_json('{}')).to be_a GlueGun::Drawing
    end

    it 'should parse the id' do
      drawing = GlueGun::Drawing.from_json('{"id": "something"}')

      expect(drawing.id).to eq 'something'
    end

    it 'should parse the image' do
      image = 'my very pretty picture'
      json = JSON.dump image: Base64.encode64(image).strip

      drawing = GlueGun::Drawing.from_json json

      expect(drawing.image).to eq image
    end
  end

  describe '#to_json' do
    it 'should convert id' do
      drawing = GlueGun::Drawing.new 42, nil
      raw_drawing = JSON.parse drawing.to_json

      expect(raw_drawing['id']).to eq 42
    end

    it 'should convert image' do
      drawing = GlueGun::Drawing.new nil, 'family photos'
      raw_drawing = JSON.parse drawing.to_json

      expect(Base64.decode64 raw_drawing['image']).to eq 'family photos'
    end
  end
end