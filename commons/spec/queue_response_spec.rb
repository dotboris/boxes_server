require 'boxes/queue_response'

describe Boxes::QueueResponse do
  let(:channel) { double 'chanel' }
  let(:tag) { double 'tag' }
  let(:response) { Boxes::QueueResponse.new channel, tag }

  describe '#ack' do
    it 'should ack the channel with the tag' do
      expect(channel).to receive(:ack).with(tag, false)

      response.ack
    end
  end

  describe '#nack' do
    it 'should nack the channel with the tag' do
      expect(channel).to receive(:nack).with(tag, false, true)

      response.nack
    end
  end
end