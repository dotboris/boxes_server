require 'faraday'

module ApiHelpers
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

  def drivethrough
    @drivethrough ||= Service.new 'http://127.0.0.1:23456/'
  end
end

World(ApiHelpers)