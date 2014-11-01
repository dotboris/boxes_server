require 'spec_helper'
require 'gluegun/request'

describe GlueGun::Request do
  let(:request) { GlueGun::Request.new 'a.queue', 42, 55, 200, 300 }

  it 'should have a queue' do
    expect(request).to respond_to :queue, :queue=
    expect(request.queue).to eq 'a.queue'
  end

  it 'should have a row count' do
    expect(request).to respond_to :row_count, :row_count=
    expect(request.row_count).to eq 42
  end

  it 'should have a col count' do
    expect(request).to respond_to :col_count, :col_count=
    expect(request.col_count).to eq 55
  end

  it 'should have a width' do
    expect(request).to respond_to :width, :width=
    expect(request.width).to eq 200
  end

  it 'should have a height' do
    expect(request).to respond_to :height, :height
    expect(request.height).to eq 300
  end

  describe '#from_json' do
    it 'should return a request' do
      json = '{"queue": "boxes.collages.1234567", "row_count": 5}'
      expect(GlueGun::Request.from_json(json)).to be_a GlueGun::Request
    end

    it 'should parse json' do
      json = '{"queue": "boxes.collages.asdfg", "row_count": 2, "col_count": 3, "width": 100, "height": 400}'

      request = GlueGun::Request.from_json(json)

      expect(request.queue).to eq 'boxes.collages.asdfg'
      expect(request.row_count).to eq 2
      expect(request.col_count).to eq 3
      expect(request.width).to eq 100
      expect(request.height).to eq 400
    end
  end
end
