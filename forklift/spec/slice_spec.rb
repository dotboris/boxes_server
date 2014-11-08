require 'spec_helper'
require 'base64'
require 'forklift/slice'

describe Forklift::Slice do
  let(:slice) { Forklift::Slice.new 'some_queue', 52, 'pix' }

  it 'should have a queue' do
    expect(slice).to respond_to :queue, :queue=
    expect(slice.queue).to eq 'some_queue'
  end

  it 'should have an id' do
    expect(slice).to respond_to :id, :id=
    expect(slice.id).to eq 52
  end

  it 'should have an image' do
    expect(slice).to respond_to :image, :image=
    expect(slice.image).to eq 'pix'
  end

  describe '#to_json' do
    it 'should convert the queue and id' do
      slice = Forklift::Slice.new 'butts', 1234, nil
      json = JSON.parse slice.to_json

      expect(json['id']).to eq 1234
      expect(json['queue']).to eq 'butts'
    end

    it 'should convert image' do
      slice = Forklift::Slice.new nil, nil, 'some pix'
      json = JSON.parse slice.to_json

      expect(Base64.decode64 json['image']).to eq 'some pix'
    end
  end
end