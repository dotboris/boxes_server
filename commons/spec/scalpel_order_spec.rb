require 'spec_helper'
require 'scalpel/order'
require 'base64'

describe Scalpel::Order do
  describe '#from_json' do
    it 'should load an order from json string' do
      json = %{{"image": "#{Base64.encode64('something').chomp}", "x": 2, "y": 3}}

      order = Scalpel::Order.from_json json

      expect(order.x).to eql 2
      expect(order.y).to eql 3
      expect(order.image).to eql 'something'
    end
  end

  describe '#to_json' do
    it 'should include x and y' do
      order = Scalpel::Order.new 'image', 3, 5

      json = order.to_json

      expect(JSON.parse(json)['x']).to eq 3
      expect(JSON.parse(json)['y']).to eq 5
    end

    it 'should base64 encode the image' do
      order = Scalpel::Order.new 'image', 1, 2

      json = order.to_json

      expect(JSON.parse(json)['image']).to eq Base64.encode64('image').chomp
    end
  end
end