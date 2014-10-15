require 'spec_helper'
require 'boxes/admin_runner'
require 'scalpel/order'

describe Boxes::AdminRunner do
  let(:runner) { Boxes::AdminRunner.new }

  describe '#ingest' do
    it 'should create an order with its argument' do
      order = double('order', to_json: 'something')
      expect(Scalpel::Order).to receive(:new).with('image', 4, 5).and_return(order)

      runner.ingest 'image', '4', '5'
    end

    it 'should make send the order json to the boxes.uncut message queue'
    it 'should connect to rabbitmq server with :mq_url option' do
      expect(Boxes).to receive(:bunny).with('butthole')

      runner.ingest 'image', '4', '5', mq_url: 'butthole'
    end
  end
end