module BootstrapHelper
  def inject_test_env!
    ENV['BOXES_AMQP_URL'] = amqp_url
  end

  def is_alive?(pid)
    Process.kill 0, pid
    return true
  rescue
    return false
  end

  def start_gluegun!
    cmd = Bundler.with_clean_env do
      inject_test_env!
      IO.popen(%w(ruby -r bundler/setup ./bin/gluegun), 'r')
    end

    sleep 2

    pid = cmd.pid
    raise "Failed to start gluegun. Output: \n#{cmd.read}" unless is_alive? cmd.pid
    puts "Started gluegun @#{pid}"

    at_exit do
      puts "killing gluegun @#{pid}"
      Process.kill 15, pid
    end
  end
end

World(BootstrapHelper)

Before do
  unless $bootstrapped
    start_gluegun!

    $bootstrapped = true
  end
end