require 'open3'
require 'tmpdir'
require 'bundler'

module Boxes
  module Test
    module Daemon
      def is_alive?(pid)
        Process.kill 0, pid
        return true
      rescue
        return false
      end

      def outputs
        @outputs ||= {}
      end

      def waiters
        @waiters ||= {}
      end

      def start!(name, command)
        outputs[name], waiters[name] = Bundler.with_clean_env do
          inject_test_env!
          Dir.chdir File.expand_path(name.to_s, project_root) do
            _, out, waiter = Open3.popen2e *command

            [out, waiter]
          end
        end

        sleep 2

        raise "Failed to start #{name}" unless is_alive? waiters[name].pid
        puts "Started #{name} @#{waiters[name].pid}"
      end

      def start_service!(name, port)
        start! name, ['thin', '-rbundler/setup', '-a', '127.0.0.1', '-p', port.to_s, 'start']
      end

      def start_daemon!(name)
        start! name, ['ruby', '-rbundler/setup', "./bin/#{name}"]
      end

      def kill_daemon!(name)
        puts "killing #{name} @#{waiters[name].pid}"
        Process.kill 15, waiters[name].pid
        waiters[name].value
      end

      def dump_daemon_output(name)
        puts "#{name} output:"
        puts outputs[name].read
      end
    end
  end
end