require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

Rake::Task[:release].clear.comment = 'Disabled to prevent accidental push to rubygems'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

