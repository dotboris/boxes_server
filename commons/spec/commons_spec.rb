require 'spec_helper'
require 'boxes'

describe Boxes do
  it 'has a version number' do
    expect(Boxes::VERSION).not_to be nil
  end

  describe '#bunny' do
    it 'should grab the bunny url from the environment' do
      ENV['BOXES_AMQP_URL'] = 'something'

      expect(Bunny).to receive(:new).with('something')

      Boxes.bunny
    end

    it 'should default to a localhost url when it is not in the environment' do
      ENV['BOXES_AMQP_URL'] = nil

      expect(Bunny).to receive(:new).with('amqp://localhost')

      Boxes.bunny
    end
  end

  describe '#media_root' do
    it 'should grab the root from the environment' do
      ENV['BOXES_MEDIA_ROOT'] = '/some/crazy/path'
      expect(Boxes.media_root.to_s).to eq '/some/crazy/path'
    end

    it 'should default to the working directory' do
      ENV['BOXES_MEDIA_ROOT'] = nil
      expect(Boxes.media_root).to eq Pathname.new '.'
    end

    it 'should return a pathname' do
      expect(Boxes.media_root).to be_kind_of Pathname
    end
  end
end