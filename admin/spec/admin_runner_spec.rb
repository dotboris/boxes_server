require 'spec_helper'
require 'boxes/admin_runner'

describe Boxes::AdminRunner do
  let(:runner) { Boxes::AdminRunner.new }

  describe '#ingest' do
    it 'should put the base64 encoded file in the request json'
    it 'should make send an order to boxes.uncut'
    it 'should include rows in json'
    it 'should include columns in json'
    it 'should connect to rabbitmq server with :mq_url option' do
      expect(Boxes).to receive(:bunny).with('butthole')

      runner.ingest nil, nil, nil, mq_url: 'butthole'
    end
  end
end