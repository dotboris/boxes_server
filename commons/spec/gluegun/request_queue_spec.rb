require 'gluegun/request_queue'
require 'bunny'

describe GlueGun::RequestQueue, :real_bunny do
  let(:queue) { GlueGun::RequestQueue.new bunny }

  describe '#publish' do
    it 'should publish the request in json' do
      request = double 'request', to_json: '{"something": "interesting"}'

      queue.publish request

      sleep 0.1

      _, _, payload = bunny.channel.queue('boxes.collages').pop

      expect(payload).to eq '{"something": "interesting"}'
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
      queue = bunny.channel.queue 'boxes.collages'
      queue.publish '{"some": "json"}'

      # make sure we call the body of block
      allow(block).to receive(:call).and_call_original
    end

    it 'should yield a response', timeout: 5 do
      expect(block).to receive(:call).with(anything, kind_of(Boxes::QueueResponse))

      queue.subscribe &block
    end

    it 'should yield a request', timeout: 5 do
      request = double 'request'
      allow(GlueGun::Request).to receive(:from_json).and_return(request)

      expect(block).to receive(:call).with(request, anything)

      queue.subscribe &block
    end
  end
end