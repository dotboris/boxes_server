$:.unshift File.expand_path('../tasks', __FILE__)

require 'build'

GEMS = %w{commons}
task :spec do
  GEMS.each { |g| sh "cd #{g}; rake" }
end

task :default => 'all:spec'