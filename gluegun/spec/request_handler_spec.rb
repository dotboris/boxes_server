require 'gluegun/request'
require 'gluegun/request_handler'
require 'gluegun/mosaic_maker'

describe GlueGun::RequestHandler do
  let(:connection) { double 'connection' }
  let(:collage_queue) { double 'collage queue', publish: nil }
  let(:handler) { GlueGun::RequestHandler.new connection, collage_queue }

  let(:collector) { double 'collector', call: []}
  let(:queue) { double 'queue', delete: nil }
  let(:maker) { double 'mosaic maker', call: double('collage', to_blob: nil) }

  let(:request) { GlueGun::Request.new SecureRandom.uuid, 1, 1, 1, 1 }
  let(:response) { double 'response', ack: nil }

  before do
    allow(GlueGun::DrawingQueue).to receive(:new).and_return(queue)
    allow(GlueGun::Collector).to receive(:new).and_return(collector)
    allow(GlueGun::MosaicMaker).to receive(:new).and_return(maker)
  end

  it 'should collect drawings', :noisy do
    request = GlueGun::Request.new 'the.prettiest.little.queue', 3, 2, 1000, 1000
    allow(collector).to receive(:call).and_return(['fi', nil, 'fum'])

    expect(GlueGun::DrawingQueue).to receive(:new).with(connection, 'the.prettiest.little.queue')
    expect(GlueGun::Collector).to receive(:new).with(queue, 6)

    handler.call(request, response)
  end

  it 'should build a mosaic with the image', :noisy do
    request = GlueGun::Request.new nil, 2, 3, 150, 200
    allow(collector).to receive(:call).and_return(%w{a b c d e f})

    expect(GlueGun::MosaicMaker).to receive(:new).with(3, 2, 50, 100)
    expect(maker).to receive(:call).with(%w(a b c d e f))

    handler.call(request, response)
  end

  it 'should publish the collage', :noisy do
    collage = double 'collage', to_blob: 'pix'
    allow(maker).to receive(:call).and_return collage

    expect(collage_queue).to receive(:publish).with('pix')

    handler.call(request, response)
  end

  it 'should delete the drawings queue', :noisy do
    expect(queue).to receive(:delete)

    handler.call request, response
  end

  it 'should ack the response', :noisy do
    expect(response).to receive(:ack)

    handler.call request, response
  end
end