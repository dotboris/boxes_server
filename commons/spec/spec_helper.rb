$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'boxes'
require 'fakefs/spec_helpers'

RSpec.configure do |c|
  c.around(:example) do |example|
    if example.metadata[:timeout]
      Timeout.timeout(example.metadata[:timeout]) do
        example.run
      end
    else
      example.run
    end
  end
end