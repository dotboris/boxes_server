require 'bundler/setup'
require 'bunny'
require 'securerandom'
require 'json'
require 'base64'
require 'RMagick'
require 'rspec'

require 'boxes/test/env'
require 'boxes/test/daemon'

World(
    Boxes::Test::Env,
    Boxes::Test::Daemon
)

Before do
  drop_all_queues!
  start_daemon! :gluegun
end

After do |s|
  kill_daemon! :gluegun
  dump_daemon_output :gluegun if s.failed?
end