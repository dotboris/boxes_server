require 'spec_helper'

describe DriveThrough do
  describe '#create!' do
    it 'should return a drive through' do
      allow(Boxes).to receive(:bunny).and_return(double('connection').as_null_object)

      expect(DriveThrough.create!).to be_a DriveThrough
    end

    it 'should build create a connection from the environment' do
      expect(Boxes).to receive(:bunny).and_return(double('connection').as_null_object)

      DriveThrough.create!
    end
  end

  describe '#slice' do
    it 'should get a slice from the queue' do
      slices_queue = double('slices')
      allow(slices_queue).to receive(:pop).and_return([nil, nil, 'something inappropriate'])
      dt = DriveThrough.new slices_queue, double('requests')

      expect(dt.slice).to eq 'something inappropriate'
    end

    it 'should request more slices when queue is empty' do
      slices_queue = double('slices')
      requests_queue = double('request')
      allow(slices_queue).to receive(:pop).and_return([nil, nil, nil])
      allow(slices_queue).to receive(:subscribe)
      dt = DriveThrough.new slices_queue, requests_queue

      expect(requests_queue).to receive(:publish)

      dt.slice
    end

    it 'should wait for the request slice' do
      slices_queue = double('slices')
      requests_queue = double('request')
      allow(slices_queue).to receive(:pop).and_return([nil, nil, nil])
      allow(slices_queue).to receive(:subscribe).and_yield(nil, nil, 'something tasteful')
      allow(requests_queue).to receive(:publish)
      dt = DriveThrough.new slices_queue, requests_queue

      expect(dt.slice).to eq 'something tasteful'
    end

    it 'should raise when the requested slice takes too long' do
      slices_queue = double('slices')
      requests_queue = double('request')
      allow(slices_queue).to receive(:pop).and_return([nil, nil, nil])
      allow(slices_queue).to receive(:subscribe).and_return(:timed_out)
      allow(requests_queue).to receive(:publish)
      dt = DriveThrough.new slices_queue, requests_queue

      expect{dt.slice}.to raise_error
    end
  end
end