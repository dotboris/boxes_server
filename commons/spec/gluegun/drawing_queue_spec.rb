require 'gluegun/drawing_queue'
require 'bunny'

describe GlueGun::DrawingQueue, :real_bunny do
  let(:queue) { GlueGun::DrawingQueue.new bunny, drawing_queue_id }

  describe '#publish' do
    it 'should publish the json' do
      drawing = double 'drawing', to_json: 'some json'
      queue.publish drawing

      sleep 0.1

      raw_queue = bunny.channel.queue("boxes.drawings.#{drawing_queue_id}")
      _, _, payload = raw_queue.pop

      expect(payload).to eq 'some json'
    end
  end

  describe '#pop' do
    it 'should return nils with empty queue' do
      res = queue.pop

      expect(res).to eq [nil, nil]
    end

    context 'with something in the queue' do
      before do
        queue = bunny.channel.queue "boxes.drawings.#{drawing_queue_id}"
        queue.publish '{"some":"json"}'
      end

      it 'should return a queue response' do
        _, response = queue.pop

        expect(response).not_to be_nil
        expect(response).to be_kind_of Boxes::QueueResponse
      end

      it 'should parse the payload as drawing' do
        expect(GlueGun::Drawing).to receive(:from_json).with('{"some":"json"}')

        queue.pop
      end

      it 'should return drawing' do
        expected_drawing = double 'drawing'
        allow(GlueGun::Drawing).to receive(:from_json).and_return(expected_drawing)

        drawing, _ = queue.pop

        expect(drawing).to eq expected_drawing
      end
    end
  end

  describe '#delete' do
    it 'should delete the queue' do
      queue.delete

      sleep 0.1

      expect{bunny.channel.queue_purge("boxes.drawings.#{drawing_queue_id}")}.to raise_error(Bunny::NotFound)
    end
  end
end