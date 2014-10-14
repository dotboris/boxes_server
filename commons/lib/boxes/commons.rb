require 'bunny'
require 'pathname'
require 'boxes/commons/version'

module Boxes
  module Commons
    def self.bunny
      url = ENV['BOXES_AMQP_URL'] || 'amqp://localhost'
      Bunny.new url
    end

    def self.media_root
      root = ENV['BOXES_MEDIA_ROOT'] || '.'
      Pathname.new root
    end
  end
end