$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'boxes'
require 'fakefs/spec_helpers'
require 'boxes/test/env'
require 'boxes/test/rabbitmq'
require 'boxes/test/mongodb'

POSSIBLY_DIRTY_ENV_VARS = %w{
  BOXES_AMQP_URL
  BOXES_MEDIA_ROOT
  BOXES_MONGODB_URL
}

RSpec.configure do |c|
  c.include Boxes::Test::Env
  c.include Boxes::Test::RabbitMq
  c.include Boxes::Test::MongoDb

  c.around(:example) do |example|
    if example.metadata[:timeout]
      Timeout.timeout(example.metadata[:timeout]) do
        example.run
      end
    else
      example.run
    end
  end

  c.around(:example, :dirties_env) do |example|
    old_env = POSSIBLY_DIRTY_ENV_VARS.map { |k| [k, ENV[k]] }
    example.run
    old_env.each { |k, v| ENV[k] = v }
  end

  c.around(:example, :real_bunny) do |example|
    inject_test_env!
    drop_all_queues!
    example.run
    drop_drawing_queue
    bunny_disconnect
  end

  c.around(:example, :real_mongo) do |example|
    clear_drawings_collection!
    example.run
  end
end