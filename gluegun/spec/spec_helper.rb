$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gluegun'

RSpec.configure do |c|
  c.before(:example, :noisy) do
    # stfu
    allow(STDOUT).to receive(:write)
  end
end