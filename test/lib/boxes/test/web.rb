require 'faraday'

module Boxes
  module Test
    module Web
      class Service
        attr_reader :last_response

        def initialize(url)
          @client = Faraday.new url
          @last_response = nil
        end

        [:get, :post, :patch, :put, :delete, :options, :head].each do |method|
          define_method method do |*args|
            @last_response = @client.public_send method, *args
          end
        end
      end

      def services
        @services ||= {}
      end

      def service(name, port)
        if services.has_key? name
          services[name]
        else
          services[name] = Service.new "http://127.0.0.1:#{port}"
        end
      end

      def drivethrough
        service :drivethrough, drivethrough_port
      end
    end
  end
end