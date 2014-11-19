require 'bundler/setup'
require 'bunny'
require 'json'
require 'base64'
require 'RMagick'
require 'rspec'

require 'boxes/test/env'
require 'boxes/test/daemon'
require 'boxes/test/rabbitmq'

World(
    Boxes::Test::Env,
    Boxes::Test::Daemon,
    Boxes::Test::RabbitMq
)

Before do
  drop_all_queues!
  start_daemon! :gluegun
end

After do |s|
  drop_drawing_queue
  kill_daemon! :gluegun
  dump_daemon_output :gluegun if s.failed?

  bunny_disconnect
end