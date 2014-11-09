require 'open3'

def run_boxes_ctl(command, *args)
  cmd = %w{ruby -r bundler/setup ./bin/boxesctl} + [command, '--mq_url', amqp_url] + args
  run_in_dir('admin', *cmd)
end

When(/ingest "([^"]*)" cut in (\d+)x(\d+)/) do |file, rows, cols|
  run_boxes_ctl('ingest', image_path(file), rows, cols)
  sleep 2 # let time for scalpel to finish
end