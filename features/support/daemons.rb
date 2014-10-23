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
  unless $tmp_media_root
    $tmp_media_root = Pathname.new(Dir.mktmpdir)
    puts "Created tmp media root #{$tmp_media_root}"

    at_exit do
      FileUtils.rm_rf $tmp_media_root
      puts "Deleted tmp media root #{$tmp_media_root}"
    end
  end

  $tmp_media_root
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

def start_daemon!(name)
  cmd = Bundler.with_clean_env do
    inject_test_env!
    Dir.chdir name do
      IO.popen(['ruby', '-rbundler/setup', "./bin/#{name}"], 'r')
    end
  end

  sleep 2

  pid = cmd.pid
  raise "Failed to start #{name}. Output: \n#{cmd.read}" unless is_alive? cmd.pid
  puts "Started #{name} @#{pid}"

  at_exit do
    puts "killing #{name} @#{pid}"
    Process.kill 15, pid
  end
end

inject_test_env!
start_daemon! 'scalpel'
start_daemon! 'forklift'
