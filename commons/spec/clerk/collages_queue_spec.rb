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

  describe '#subscribe' do
    # block that will successfully exit out of the blocking subscribe call
    let(:block) do
      proc do
        # Fiddle with the insides of the request queue to be able to exit out of the blocking subscribe
        # This makes the test very dependant on the internal implementation of the queue
        inner_channel = queue.instance_variable_get(:@channel)
        inner_channel.close
      end
    end

    before do
      allow(block).to receive(:call).and_call_original
    end

    it 'should yield the raw payload' do
      bunny.channel.queue('boxes.collages.ingest').publish 'some kind of an image maybe'

      expect(block).to receive(:call).with('some kind of an image maybe')

      queue.subscribe &block

      sleep 0.2
    end
  end
end