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
    @gluegun = Bundler.with_clean_env do
      inject_test_env!
      IO.popen(%w(ruby -r bundler/setup ./bin/gluegun), 'r')
    end

    sleep 1

    raise 'Failed to start gluegun.' unless is_alive? @gluegun.pid
    puts "Started gluegun @#{@gluegun.pid}"
  end

  def kill_gluegun!
    puts "killing gluegun @#{@gluegun.pid}"
    Process.kill 15, @gluegun.pid
  end

  def print_gluegun_output
    puts 'GlueGun output: '
    puts @gluegun.read
  end
end

World(BootstrapHelper)

Before do
  start_gluegun!
end

After do |s|
  kill_gluegun!
  print_gluegun_output if s.failed?
end