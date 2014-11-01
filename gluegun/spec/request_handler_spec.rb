require 'gluegun/request'
require 'gluegun/request_handler'

describe GlueGun::RequestHandler do
  let(:connection) { double 'connection' }
  let(:handler) { GlueGun::RequestHandler.new connection }

  it 'should collect drawings', :noisy do
    request = GlueGun::Request.new 'the.prettiest.little.queue', 3, 2
    queue = double 'queue'
    collector = double 'collector', call: ['fi', nil, 'fum']

    expect(GlueGun::DrawingQueue).to receive(:new).with(connection, 'the.prettiest.little.queue').and_return(queue)
    expect(GlueGun::Collector).to receive(:new).with(queue, 6).and_return(collector)

    handler.call(request, double.as_null_object)
  end
end