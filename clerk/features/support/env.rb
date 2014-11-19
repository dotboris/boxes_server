require 'rspec'

require 'boxes/test/env'
require 'boxes/test/daemon'
require 'boxes/test/mongodb'
require 'boxes/test/rabbitmq'

World(
    Boxes::Test::Env,
    Boxes::Test::Daemon,
    Boxes::Test::MongoDb,
    Boxes::Test::RabbitMq
)

Before do
  drop_all_queues!
  clear_drawings_collection!
  start_daemon! :clerk
end

After do |s|
  kill_daemon! :clerk rescue nil
  dump_daemon_output :clerk if s.failed?
end