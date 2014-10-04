$:.unshift File.expand_path('../tasks', __FILE__)

require 'build'

GEMS = %w{commons}
task :spec do
  GEMS.each { |g| sh "cd #{g}; #{$0} spec" }
end

task :default => 'all:spec'