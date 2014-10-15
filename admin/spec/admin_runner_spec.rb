require 'spec_helper'
require 'boxes/admin_runner'
require 'scalpel/order'

describe Boxes::AdminRunner do
  let(:runner) { Boxes::AdminRunner.new }

  describe '#ingest' do
    include FakeFS::SpecHelpers

    before do
      allow(Boxes).to receive(:bunny).and_return(double('bunny').as_null_object)

      FileUtils.mkpath('/path/to')
      FileUtils.touch('/path/to/image')
    end

    it 'should create an order with its argument' do
      File.write '/path/to/image', 'image_contents'

      expect(Scalpel::Order).to receive(:new).with('image_contents', 5, 4)

      runner.ingest '/path/to/image', '4', '5'
    end

    it 'should connect to rabbitmq server with :mq_url option' do
      expect(Boxes).to receive(:bunny).with('butthole')

      runner.ingest '/path/to/image', '4', '5', mq_url: 'butthole'
    end
  end
end