require 'gluegun/request_queue'
require 'bunny'

describe GlueGun::RequestQueue do
  before do
    @connection = Bunny.new 'amqp://boxes:boxes@localhost'
    @connection.start
  end

  after do
    @connection.close
  end

  let(:queue) { GlueGun::RequestQueue.new @connection }

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
      channel = @connection.channel
      channel.queue_purge 'boxes.collages'
      queue = channel.queue 'boxes.collages'
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