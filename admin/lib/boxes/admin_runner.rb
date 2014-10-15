require 'boson/runner'
require 'boxes'
require 'scalpel/order'

module Boxes
  class AdminRunner < Boson::Runner
    def self.rabbitmq_options
      option :mq_url, type: :string, desc: 'URL to access the rabbitmq instance. (ex: amqp://somehost:1234)'
    end

    rabbitmq_options
    desc 'Ingest an image into the boxes server. The image will be split into the given number of rows and columns.'
    def ingest(image, rows, columns, options={})
      json = Scalpel::Order.new(File.read(image), rows.to_i, columns.to_i).to_json

      connection = Boxes.bunny options[:mq_url]
      connection.start
      channel = connection.create_channel
      queue = channel.queue 'boxes.uncut'
      channel.default_exchange.publish json, routing_key: queue.name
    end
  end
end