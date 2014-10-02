require 'mixlib/cli'
require 'boxes/version'

module Boxes
  class Cli
    include Mixlib::CLI

    def initialize(name)
      super()
      @banner = "usage: #{name} [options]"
    end

    option :version, short: '-v', long: '--version',
           description: 'show version information',
           on: :tail,
           boolean: true,
           proc: proc { puts Boxes::VERSION },
           exit: 0

    option :help, short: '-h', long: '--help',
           description: 'show this message',
           on: :tail,
           boolean: true,
           show_options: true,
           exit: 0
  end
end
