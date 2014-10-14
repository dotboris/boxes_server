require 'bunny'
require 'boxes/commons/version'

module Boxes
  module Commons
    def self.bunny
      url = ENV['BOXES_AMQP_URL'] || 'amqp://localhost'
      Bunny.new url
    end
  end
end