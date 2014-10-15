require 'spec_helper'
require 'boxes/admin_runner'
require 'scalpel/order'

describe Boxes::AdminRunner do
  let(:runner) { Boxes::AdminRunner.new }

  describe '#ingest' do
    before do
      allow(Boxes).to receive(:bunny).and_return(double('bunny').as_null_object)
    end

    it 'should create an order with its argument' do
      expect(Scalpel::Order).to receive(:new).with('image', 4, 5)

      runner.ingest 'image', '4', '5'
    end

    it 'should connect to rabbitmq server with :mq_url option' do
      expect(Boxes).to receive(:bunny).with('butthole')

      runner.ingest 'image', '4', '5', mq_url: 'butthole'
    end
  end
end