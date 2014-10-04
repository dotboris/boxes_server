require 'mixlib/cli'
require 'boxes/commons/version'

module Boxes
  module Commons
    class Cli
      include Mixlib::CLI

      def initialize(name)
        super()
        @banner = "usage: #{name} [options]"
      end

      option :mq_host, long: '--mq-host HOST',
             description: 'host for the rabbit mq instance',
             default: 'localhost'

      option :mq_port, long: '--mq-port PORT',
             desctiption: 'port for the rabbit mq instance',
             proc: proc {|port| port.to_i},
             default: 5672

      option :version, short: '-v', long: '--version',
             description: 'show version information',
             on: :tail,
             boolean: true,
             proc: proc { puts Boxes::Commons::VERSION },
             exit: 0

      option :help, short: '-h', long: '--help',
             description: 'show this message',
             on: :tail,
             boolean: true,
             show_options: true,
             exit: 0
    end
  end
end
