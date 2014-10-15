require 'spec_helper'
require 'boxes/admin_runner'

describe Boxes::AdminRunner do
  describe '#ingest' do
    it 'should put the base64 encoded file in the request json'
    it 'should make send an order to boxes.uncut'
    it 'should include rows in json'
    it 'should include columns in json'
    it 'should connect to rabbitmq server with :mq_url option'
  end
end