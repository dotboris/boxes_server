require 'open3'
require 'tmpdir'
require 'bundler'

module Boxes
  module Test
    module Daemon
      attr_reader :tmp_media_root

      def maybe_create_media_root
        if ENV['BOXES_MEDIA_ROOT'].nil? && tmp_media_root.nil?
          create_media_root!
        end
      end

      def maybe_delete_media_root
        delete_tmp_media_root! if tmp_media_root
      end

      def create_media_root!
        @tmp_media_root = Pathname.new(Dir.mktmpdir)
        puts "Created tmp media root #{@tmp_media_root}"
      end

      def delete_tmp_media_root!
        puts "Deleted tmp media root #{tmp_media_root}"
        tmp_media_root.rmtree
        @tmp_media_root = nil
      end

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
          Dir.chdir name.to_s do
            _, out, waiter = Open3.popen2e *command

            [out, waiter]
          end
        end

        sleep 2

        raise "Failed to start #{name}" unless is_alive? waiters[name].pid
        puts "Started #{name} @#{waiters[name].pid}"
      end

      def start_service!(name)
        start! name, %w(thin -r bundler/setup -a 127.0.0.1 -p 23456 start)
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