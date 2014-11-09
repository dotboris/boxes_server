require 'spec_helper'
require 'rack/test'
require 'drivethrough/api'

describe DriveThrough::Api do
  include Rack::Test::Methods

  let(:drivethrough) { double('drive_through') }

  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:dt).and_return(drivethrough)
    end
  end

  def app
    DriveThrough::Api
  end

  describe 'GET /slice' do
    it 'should return 408 when drive through times out' do
      allow(drivethrough).to receive(:slice).and_raise(DriveThrough::Queue::Timeout)

      get '/slice'

      expect(last_response.status).to eq 408
    end

    it 'should return whatever #split returns' do
      allow(drivethrough).to receive(:slice).and_return('butthole')

      get '/slice'

      expect(last_response.body).to eq 'butthole'
    end

    it 'should have application/json as the content type' do
      allow(drivethrough).to receive(:slice).and_return(nil)

      get '/slice'

      expect(last_response.content_type).to eq 'application/json'
    end

    it 'should have no caching' do
      allow(drivethrough).to receive(:slice).and_return(nil)

      get '/slice'

      expect(last_response['Cache-Control']).to eq 'no-cache'
    end
  end
end