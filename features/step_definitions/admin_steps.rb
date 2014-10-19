require 'open3'

def run_boxes_ctl(command, *args)
  Bundler.with_clean_env do
    inject_test_env!
    Dir.chdir 'admin' do
      cmd = %w{ruby -r bundler/setup ./bin/boxesctl} + [command, '--mq_url', amqp_url] + args
      Open3.popen2e(*cmd) do |_, out, waiter|
        status = waiter.value
        raise "boxesctl failed with status code #{status.exitstatus} output:\n#{out.read}" unless status.success?
      end
    end
  end
end

When(/ingest "([^"]*)" cut in (\d+)x(\d+)/) do |file, rows, cols|
  run_boxes_ctl('ingest', file, rows, cols)
end