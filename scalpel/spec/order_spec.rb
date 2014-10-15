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
end