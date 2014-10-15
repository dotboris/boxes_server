require 'boson/runner'
require 'boxes'

module Boxes
  class AdminRunner < Boson::Runner
    def self.rabbitmq_options
      option :mq_url, type: :string, desc: 'URL to access the rabbitmq instance. (ex: amqp://somehost:1234)'
    end

    rabbitmq_options
    desc 'Ingest an image into the boxes server. The image will be split into the given number of rows and columns.'
    def ingest(image, rows, columns, options={})
      connection = Boxes.bunny options[:mq_url]
    end
  end
end