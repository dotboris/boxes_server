require 'spec_helper'
require 'drivethrough/api'
require 'rack/test'
require 'base64'

describe DriveThrough::Api do
  include Rack::Test::Methods

  def app
    DriveThrough::Api
  end

  describe 'PUT /drawings/:queue/:index' do
    before do
      ENV['BOXES_AMQP_URL'] = 'amqp://boxes:boxes@localhost'
    end

    before do
      @connection = Bunny.new 'amqp://boxes:boxes@localhost'
      @connection.start

      @connection.channel.queue_purge 'boxes.drawings.testing' rescue nil
    end

    after do
      @connection.close
    end

    it 'should send a drawing' do
      put '/drawings/testing/3', 'butts', 'CONTENT_TYPE' => 'image/png'

      expect(last_response.status).to eq 200

      sleep 0.1

      _, _, payload = @connection.channel.queue('boxes.drawings.testing').pop
      drawing = JSON.parse payload

      expect(drawing['id']).to eq 3
      expect(Base64.decode64 drawing['image']).to eq 'butts'
    end
  end
end