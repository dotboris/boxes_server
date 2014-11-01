require 'spec_helper'
require 'gluegun/drawing'
require 'base64'

describe Gluegun::Drawing do
  let(:drawing) { Gluegun::Drawing.new 'a special snowflake', 'baby photos' }

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
      expect(Gluegun::Drawing.from_json('{}')).to be_a Gluegun::Drawing
    end

    it 'should parse the id' do
      drawing = Gluegun::Drawing.from_json('{"id": "something"}')

      expect(drawing.id).to eq 'something'
    end

    it 'should parse the image' do
      image = 'my very pretty picture'
      json = JSON.dump image: Base64.encode64(image).strip

      drawing = Gluegun::Drawing.from_json json

      expect(drawing.image).to eq image
    end
  end
end