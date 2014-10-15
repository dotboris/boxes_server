require 'spec_helper'
require 'boxes/admin_runner'

describe Boxes::AdminRunner do
  let(:runner) { Boxes::AdminRunner.new }

  describe '#ingest' do
    it 'should create an order with its argument'
    it 'should make send the order json to the boxes.uncut message queue'
    it 'should connect to rabbitmq server with :mq_url option' do
      expect(Boxes).to receive(:bunny).with('butthole')

      runner.ingest nil, nil, nil, mq_url: 'butthole'
    end
  end
end