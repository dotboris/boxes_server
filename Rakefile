require 'bundler/setup'

$:.unshift File.expand_path('../tasks', __FILE__)

PROJECTS = %w{commons scalpel}

require 'gems'
require 'build'
require 'run'

desc 'Run specs on all gems'
task :spec do
  PROJECTS.each { |g| sh "cd #{g}; #{$0} spec" }
end

desc 'Clean up the packages'
task :clean => 'all:docker:clean' do
  rm_rf 'pkg'
end

task :default => 'spec'