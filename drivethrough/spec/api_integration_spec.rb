require 'spec_helper'
require 'drivethrough/api'
require 'rack/test'
require 'base64'

describe DriveThrough::Api do
  include Rack::Test::Methods

  def app
    DriveThrough::Api
  end

  before do
    inject_test_env!
    drop_all_queues!
  end

  after do
    bunny_disconnect
  end

  describe 'GET /slice' do
    it 'should return queue, id, and image' do
      bunny.channel.queue('boxes.slices').publish '{"id": 55, "queue": "butts", "image": "pix"}'
      sleep 0.1

      get '/slice'
      slice = JSON.parse last_response.body

      expect(slice['id']).to eq 55
      expect(slice['queue']).to eq 'butts'
      expect(slice['image']).to eq 'pix'
    end
  end

  describe 'PUT /drawings/:queue/:index' do
    it 'should send a drawing' do
      put "/drawings/#{drawing_queue_id}/3", 'butts', 'CONTENT_TYPE' => 'image/png'

      expect(last_response.status).to eq 200

      sleep 0.1

      _, _, payload = bunny.channel.queue("boxes.drawings.#{drawing_queue_id}").pop
      drawing = JSON.parse payload

      expect(drawing['id']).to eq 3
      expect(Base64.decode64 drawing['image']).to eq 'butts'
    end
  end
end