require 'spec_helper'
require 'scalpel/order'
require 'base64'

describe Scalpel::Order do
  describe '#from_json' do
    it 'should load an order from json string' do
      json = %{{"image": "#{Base64.encode64('something').chomp}", "columns": 2, "rows": 3}}

      order = Scalpel::Order.from_json json

      expect(order.columns).to eql 2
      expect(order.rows).to eql 3
      expect(order.image).to eql 'something'
    end
  end

  describe '#to_json' do
    it 'should include columns and rows' do
      order = Scalpel::Order.new 'image', 3, 5

      json = order.to_json

      expect(JSON.parse(json)['rows']).to eq 3
      expect(JSON.parse(json)['columns']).to eq 5
    end

    it 'should base64 encode the image' do
      order = Scalpel::Order.new 'image', 1, 2

      json = order.to_json

      expect(JSON.parse(json)['image']).to eq Base64.encode64('image').chomp
    end
  end
end