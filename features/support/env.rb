require 'bundler/setup'
require 'rspec'
require 'base64'

require 'boxes/test/env'
require 'boxes/test/daemon'
require 'boxes/test/rabbitmq'
require 'boxes/test/mongodb'
require 'boxes/test/web'

World(
    Boxes::Test::Env,
    Boxes::Test::RabbitMq,
    Boxes::Test::MongoDb,
    Boxes::Test::Web,
    Boxes::Test::Daemon
)

Before do
  drop_all_queues!
  clear_drawings_collection!
end

Before('@drivethrough') do
  start_service! :drivethrough, drivethrough_port
end

Before('@gallery') do
  start_service! :gallery, gallery_port
end

Before('@clerk') do
  start_daemon! :clerk
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

[:scalpel, :forklift, :gluegun, :drivethrough, :clerk, :gallery].each do |daemon|
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