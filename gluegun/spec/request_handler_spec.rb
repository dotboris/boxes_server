require 'gluegun/request'
require 'gluegun/request_handler'
require 'gluegun/mosaic_maker'

describe GlueGun::RequestHandler do
  let(:connection) { double 'connection' }
  let(:handler) { GlueGun::RequestHandler.new connection }

  let(:collector) { double 'collector', call: []}
  let(:queue) { double 'queue' }
  let(:maker) { double 'mosaic maker', call: nil}

  before do
    allow(GlueGun::DrawingQueue).to receive(:new).and_return(queue)
    allow(GlueGun::Collector).to receive(:new).and_return(collector)
    allow(GlueGun::MosaicMaker).to receive(:new).and_return(maker)
  end

  it 'should collect drawings', :noisy do
    request = GlueGun::Request.new 'the.prettiest.little.queue', 3, 2
    allow(collector).to receive(:call).and_return(['fi', nil, 'fum'])

    expect(GlueGun::DrawingQueue).to receive(:new).with(connection, 'the.prettiest.little.queue')
    expect(GlueGun::Collector).to receive(:new).with(queue, 6)

    handler.call(request, double.as_null_object)
  end

  it 'should build a mosaic with the image', :noisy do
    request = GlueGun::Request.new nil, 2, 3, 50, 100
    allow(collector).to receive(:call).and_return(%w{a b c d e f})

    expect(GlueGun::MosaicMaker).to receive(:new).with(3, 2, 50, 100)
    expect(maker).to receive(:call).with(%w(a b c d e f))

    handler.call(request, double.as_null_object)
  end
end