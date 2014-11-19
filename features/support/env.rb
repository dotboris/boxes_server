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

Before('@drivethrough') do
  drop_queue 'boxes.slices'
  drop_queue 'boxes.slices.load'

  start_service! :drivethrough
end

Before('@gluegun') do
  drop_queue 'boxes.collages'
  drop_queue 'boxes.collages.ingest'

  start_daemon! :gluegun
end

Before('@scalpel') do
  drop_queue 'boxes.uncut'

  maybe_create_media_root
  start_daemon! :scalpel
end

Before('@forklift') do
  drop_queue 'boxes.slices'
  drop_queue 'boxes.slices.load'

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
  bunny_disconnect
end