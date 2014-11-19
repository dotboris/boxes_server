require 'spec_helper'
require 'clerk/collage_queue'
require 'bunny'

describe Clerk::CollageQueue, :real_bunny do
  let(:queue) { Clerk::CollageQueue.new bunny }

  describe '#publish' do
    it 'should publish the raw string' do
      queue.publish 'something'

      sleep 0.1

      _, _, payload = bunny.channel.queue('boxes.collages.ingest').pop

      expect(payload).to eq 'something'
    end
  end
end