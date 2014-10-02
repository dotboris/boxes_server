require 'spec_helper'
require 'boxes/cli'

describe Boxes::Cli do
  before do
    # cli is super noisy, kill stdout during tests
    allow($stdout).to receive(:write)
  end

  describe 'help' do
    it 'should exit' do
      cli = Boxes::Cli.new 'command'

      expect{cli.parse_options(['-h'])}.to raise_error SystemExit
    end

    it 'should output banner' do
      cli = Boxes::Cli.new 'command'
      allow(cli).to receive(:exit)

      expect{cli.parse_options(['-h'])}.to output(/^usage: command \[options\]/).to_stdout
    end
  end

  describe 'version' do
    it 'should exit' do
      cli = Boxes::Cli.new 'command'

      expect{cli.parse_options(['-v'])}.to raise_error SystemExit
    end

    it 'should output the version' do
      cli = Boxes::Cli.new 'command'
      allow(cli).to receive(:exit)

      expect{cli.parse_options ['-v']}.to output(Regexp.new Regexp.escape(Boxes::VERSION.to_s)).to_stdout
    end
  end
end