require 'spec_helper'
require 'boxes/commons/cli'

describe Boxes::Commons::Cli do
  before do
    # cli is super noisy, kill stdout during tests
    allow($stdout).to receive(:write)
  end

  let(:cli) { Boxes::Commons::Cli.new 'command' }

  describe '--help' do
    it 'should exit' do
      expect{cli.parse_options(['-h'])}.to raise_error SystemExit
    end

    it 'should output banner' do
      allow(cli).to receive(:exit)

      expect{cli.parse_options(['-h'])}.to output(/^usage: command \[options\]/).to_stdout
    end
  end

  describe '--version' do
    it 'should exit' do
      expect{cli.parse_options(['-v'])}.to raise_error SystemExit
    end

    it 'should output the version' do
      allow(cli).to receive(:exit)

      expect{cli.parse_options ['-v']}.to output(Regexp.new Regexp.escape(Boxes::Commons::VERSION.to_s)).to_stdout
    end
  end

  describe '--mq-host' do
    it 'should default to localhost' do
      cli.parse_options []

      expect(cli.config[:mq_host]).to eq('localhost')
    end
    it 'should store value in config' do
      cli.parse_options %w(--mq-host some_host)

      expect(cli.config[:mq_host]).to eq('some_host')
    end
  end

  describe '--mq-port' do
    it 'should default to 5672' do
      cli.parse_options []

      expect(cli.config[:mq_port]).to eq(5672)
    end
    it 'should convert value to int' do
      cli.parse_options %w(--mq-port 1234)

      expect(cli.config[:mq_port]).to be_kind_of(Integer)
    end

    it 'should store value in config' do
      cli.parse_options %w(--mq-port 1234)

      expect(cli.config[:mq_port]).to eq(1234)
    end
  end
end