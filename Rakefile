$:.unshift File.expand_path('../tasks', __FILE__)

require 'gems'
require 'build'

task :spec do
  GEMS.each { |g| sh "cd #{g}; #{$0} spec" }
end

task :default => 'spec'