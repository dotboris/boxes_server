require 'bundler/setup'
require 'rspec'
require 'base64'

require 'boxes/test/env'
require 'boxes/test/daemon'
require 'boxes/test/rabbitmq'
require 'boxes/test/web'

World(
    Boxes::Test::Env,
    Boxes::Test::RabbitMq,
    Boxes::Test::Web,
    Boxes::Test::Daemon
)

Before do
  drop_all_queues!
end

Before('@drivethrough') do
  start_service! :drivethrough, drivethrough_port
end

Before('@gluegun') do
  start_daemon! :gluegun
end

Before('@scalpel') do
  maybe_create_media_root
  start_daemon! :scalpel
end

Before('@forklift') do
  maybe_create_media_root
  start_daemon! :forklift
end

[:scalpel, :forklift, :gluegun, :drivethrough].each do |daemon|
  After("@#{daemon}") do |s|
    kill_daemon! daemon rescue nil
    dump_daemon_output daemon if s.failed?

    maybe_delete_media_root
  end
end

After do
  drop_drawing_queue
  bunny_disconnect
end