require 'spec_helper'
require 'gallery/api'
require 'rack/test'

describe Gallery::Api, :real_mongo do
  include Rack::Test::Methods

  def app
    Gallery::Api
  end

  describe 'GET /' do
    it 'should return an empty list when there is nothing in mongo' do
      drawings_collection.remove

      get '/'

      expect(last_response.status).to eq 200
      body = JSON.parse(last_response.body)
      expect(body).to be_kind_of Array
      expect(body.size).to eq 0
    end

    it 'should return a list of ids' do
      ids = Array.new(3).map { drawings_collection.insert({}) }.map &:to_s

      get '/'

      expect(last_response.status).to eq 200
      body = JSON.parse(last_response.body)
      expect(body).to be_kind_of Array
      expect(body.size).to eq 3
      # noinspection RubyResolve
      expect(body).to include *ids
    end

    it 'should have a json content type' do
      get '/'

      expect(last_response.content_type).to eq 'application/json'
    end
  end

  describe 'GET /:id' do
    it 'should return 404 when not found' do
      get '/nope'

      expect(last_response.status).to be 404
    end

    it 'should return the raw image' do
      id = drawings_collection.insert({image: BSON::Binary.new('pix')})

      get "/#{id}"

      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'pix'
    end

    it 'should have a png content type' do
      id = drawings_collection.insert({image: BSON::Binary.new('pix')})

      get "/#{id}"

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'image/png'
    end
  end
end