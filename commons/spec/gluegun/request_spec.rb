require 'spec_helper'
require 'gluegun/request'

describe GlueGun::Request do
  let(:gluegun) { GlueGun::Request.new 'a.queue', 42 }

  it 'should have a queue' do
    expect(gluegun).to respond_to :queue, :queue=
    expect(gluegun.queue).to eq 'a.queue'
  end

  it 'should have a row count' do
    expect(gluegun).to respond_to :row_count, :row_count=
    expect(gluegun.row_count).to eq 42
  end

  describe '#from_json' do
    it 'should return a request' do
      json = '{"queue": "boxes.collages.1234567", "row_count": 5}'
      expect(GlueGun::Request.from_json(json)).to be_a GlueGun::Request
    end

    it 'should parse json' do
      json = '{"queue": "boxes.collages.asdfg", "row_count": 2}'

      request = GlueGun::Request.from_json(json)

      expect(request.queue).to eq 'boxes.collages.asdfg'
      expect(request.row_count).to eq 2
    end
  end
end
