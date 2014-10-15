$:.unshift File.expand_path('../tasks', __FILE__)

require 'gems'
require 'run'

PROJECTS = %w{commons scalpel}

desc 'Run specs on projects'
task :spec do
  PROJECTS.each { |p| sh "cd #{p}; #{$0} spec" }
end
task :default => 'spec'

desc 'Run bundle install on all projects'
task 'bundle:install' do
  PROJECTS.each { |p| sh "cd #{p}; bundle install"}
end
