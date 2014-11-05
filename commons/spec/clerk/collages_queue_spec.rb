require 'spec_helper'
require 'clerk/collage_queue'
require 'bunny'

describe Clerk::CollageQueue do
  before do
    @connection = Bunny.new 'amqp://boxes:boxes@localhost'
    @connection.start
  end

  after do
    @connection.close
  end

  let(:queue) { Clerk::CollageQueue.new @connection }

  describe '#publish' do
    it 'should publish the raw string' do
      queue.publish 'something'

      sleep 0.1

      _, _, payload = @connection.channel.queue('boxes.collages.ingest').pop

      expect(payload).to eq 'something'
    end
  end
end