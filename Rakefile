$:.unshift File.expand_path('../tasks', __FILE__)

require 'gems'
require 'build'

desc 'Run specs on all gems'
task :spec do
  GEMS.each { |g| sh "cd #{g}; #{$0} spec" }
end

desc 'Clean up the packages'
task :clean => 'all:docker:clean' do
  rm_rf 'pkg'
end

task :default => 'spec'