require 'gluegun/drawing_queue'
require 'bunny'

describe Gluegun::DrawingQueue do
  let(:queue) { Gluegun::DrawingQueue.new @connection, 'testing' }

  before(:context) do
    @connection = Bunny.new 'amqp://boxes:boxes@localhost'
    @connection.start
  end

  after(:context) do
    @connection.close
  end

  before do
    begin
      @connection.channel.queue_purge 'boxes.drawings.testing'
    rescue Bunny::NotFound
      # ignored
    end
  end

  describe '#pop' do
    it 'should return nils with empty queue' do
      res = queue.pop

      expect(res).to eq [nil, nil]
    end

    context 'with something in the queue' do
      before do
        queue = @connection.channel.queue 'boxes.drawings.testing'
        queue.publish '{"some":"json"}'
      end

      it 'should return a queue response' do
        _, response = queue.pop

        expect(response).not_to be_nil
        expect(response).to be_kind_of Boxes::QueueResponse
      end

      it 'should parse the payload as drawing' do
        expect(Gluegun::Drawing).to receive(:from_json).with('{"some":"json"}')

        queue.pop
      end

      it 'should return drawing' do
        expected_drawing = double 'drawing'
        allow(Gluegun::Drawing).to receive(:from_json).and_return(expected_drawing)

        drawing, _ = queue.pop

        expect(drawing).to eq expected_drawing
      end
    end
  end
end