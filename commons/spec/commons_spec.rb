require 'spec_helper'
require 'boxes/commons'

describe Boxes::Commons do
  it 'has a version number' do
    expect(Boxes::Commons::VERSION).not_to be nil
  end

  describe '#bunny' do
    it 'should grab the bunny url from the environment' do
      ENV['BOXES_AMQP_URL'] = 'something'

      expect(Bunny).to receive(:new).with('something')

      Boxes::Commons.bunny
    end

    it 'should default to a localhost url when it is not in the environment' do
      ENV['BOXES_AMQP_URL'] = nil

      expect(Bunny).to receive(:new).with('amqp://localhost')

      Boxes::Commons.bunny
    end
  end
end