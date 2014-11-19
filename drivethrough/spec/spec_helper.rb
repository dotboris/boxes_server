$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'boxes/test/rabbitmq'
require 'boxes/test/env'
require 'drivethrough'

RSpec.configure do |c|
  c.include Boxes::Test::Env
  c.include Boxes::Test::RabbitMq
end