require 'gluegun/collector'

describe GlueGun::Collector do
  before do
    # speed up tests by killing sleep
    allow_any_instance_of(GlueGun::Collector).to receive(:sleep)
  end

  let(:queue) { double 'queue' }

  it 'should return all images in the right order' do
    collector = GlueGun::Collector.new queue, 3
    allow(queue).to receive(:pop).and_return(
        [GlueGun::Drawing.new(2, 'a'), double.as_null_object],
        [GlueGun::Drawing.new(0, 'b'), double.as_null_object],
        [GlueGun::Drawing.new(1, 'c'), double.as_null_object]
    )

    images, _ = collector.call

    expect(images).to eq %w(b c a)
  end

  it 'should return an ack callback' do
    collector = GlueGun::Collector.new queue, 3
    drawings = (0..2).map { |i| double "drawing #{i}", id: i, image: "image #{i}" }
    response = double 'response'
    allow(queue).to receive(:pop).and_return *drawings.zip([response] * 3)

    _, ack = collector.call

    expect(ack).to respond_to :call
  end

  it 'should not ack responses itself' do
    collector = GlueGun::Collector.new queue, 3
    drawings = (0..2).map { |i| double "drawing #{i}", id: i, image: "image #{i}" }
    response = double 'response'
    allow(queue).to receive(:pop).and_return *drawings.zip([response] * 3)

    expect(queue).to receive(:pop).exactly(3).times
    expect(response).not_to receive(:ack)

    collector.call
  end

  describe 'ack callback' do
    it 'should ack all responses' do
      collector = GlueGun::Collector.new queue, 5
      drawings = (0..5).map { |i| double "drawing #{i}", id: i, image: "image #{i}" }
      response = double 'response'
      allow(queue).to receive(:pop).and_return *drawings.zip([response] * 5)
      _, ack = collector.call

      expect(response).to receive(:ack).exactly(5).times

      ack.call
    end
  end

  it 'should ack doubles immediately' do
    collector = GlueGun::Collector.new queue, 2
    response = double 'response'
    double_response = double 'double response'
    allow(queue).to receive(:pop).and_return(
      [double('first drawing', id: 0, image: 'first'), response],
      [double('double drawing', id: 0, image: 'double'), double_response],
      [double('second drawing', id: 1, image: 'second'), response]
    )

    expect(queue).to receive(:pop).exactly(2).times.ordered
    expect(double_response).to receive(:ack).ordered
    expect(queue).to receive(:pop).ordered

    collector.call
  end

  it 'should exclude missing drawings' do
    collector = GlueGun::Collector.new queue, 3
    allow(queue).to receive(:pop).and_return(
      [double('first', id: 0, image: 'first'), double('response').as_null_object],
      [nil, nil]
    )

    images, _ = collector.call

    expect(images).to eq ['first', nil, nil]
  end
end