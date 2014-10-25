require 'tmpdir'

module BootstrapHelpers
  def create_media_root!
    $tmp_media_root = Pathname.new(Dir.mktmpdir)
    puts "Created tmp media root #{$tmp_media_root}"

    at_exit do
      FileUtils.rm_rf $tmp_media_root
      puts "Deleted tmp media root #{$tmp_media_root}"
    end
  end

  def is_alive?(pid)
    Process.kill 0, pid
    return true
  rescue
    return false
  end

  def start_service!(name)
    cmd = Bundler.with_clean_env do
      inject_test_env!
      Dir.chdir name do
        IO.popen %w(thin -r bundler/setup -a 127.0.0.1 -p 23456 start)
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
end

World(BootstrapHelpers)

Before do
  unless $bootstrapped
    create_media_root! unless ENV['BOXES_MEDIA_ROOT']
    start_daemon! 'scalpel'
    start_daemon! 'forklift'
    start_service! 'drivethrough'
    $bootstrapped = true
  end
end
