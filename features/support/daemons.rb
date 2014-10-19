require 'tmpdir'

def run_in_dir(dir, *cmd)
  Bundler.with_clean_env do
    inject_test_env!
    Dir.chdir dir do
      Open3.popen2e(*cmd) do |_, out, waiter|
        status = waiter.value
        raise "#{cmd.join(' ')} failed with status #{status.exitstatus} output:\n#{out.read}" unless status.success?
      end
    end
  end
end

def amqp_url
  ENV['BOXES_AMQP_URL'] || 'amqp://boxes:boxes@localhost'
end

def tmp_media_root
  $tmp_media_root ||= Pathname.new(Dir.mktmpdir)
end

def media_root
  ENV['BOXES_MEDIA_ROOT'] || tmp_media_root.to_s
end

def inject_test_env!
  ENV['BOXES_AMQP_URL'] = amqp_url
  ENV['BOXES_MEDIA_ROOT'] = media_root
end

def is_alive?(pid)
  Process.kill 0, pid
  return true
rescue
  return false
end

def start_scalpel!
  cmd = Bundler.with_clean_env do
    inject_test_env!
    Dir.chdir 'scalpel' do
      IO.popen(%w{ruby -r bundler/setup ./bin/scalpel}, 'r')
    end
  end

  sleep 2

  pid = cmd.pid
  raise "Failed to start scalpel. Output: \n#{cmd.read}" unless is_alive? cmd.pid
  puts "Started scalpel @#{pid}"

  at_exit do
    puts "killing scalpel @#{pid}"
    Process.kill 'KILL', pid
  end
end

inject_test_env!
start_scalpel!