require 'bundler'

PROJECTS = %w{commons scalpel forklift drivethrough admin}

desc 'Run specs on projects'
task :spec do
  PROJECTS.each do |p|
    Bundler.with_clean_env { sh "cd #{p}; #{$0} spec" }
  end
end
task :default => 'spec'

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  desc 'Run features on project'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = 'features --format pretty'
  end
  task :default => :features
rescue LoadError
  puts 'Failed to load cucumber, make sure to run bundle install first'
end

desc 'Run bundle install on all projects'
task 'bundle:install' do
  sh 'bundle install'

  Bundler.with_clean_env do
    PROJECTS.each { |p| sh "cd #{p}; bundle install" }
  end
end

namespace :rabbitmq do
  desc 'Start rabbit mq from docker'
  task :start do
    sh 'docker run -d -P --name rabbitmq -e RABBITMQ_USER=boxes -e RABBITMQ_PASS=boxes -p 5672:5672 -p 15672:15672 tutum/rabbitmq'
  end

  desc 'Stop running rabbitmq instance'
  task :stop do
    sh 'docker stop rabbitmq'
    sh 'docker rm rabbitmq'
  end

  desc 'Restart rabbitmq'
  task :restart => [:stop, :start]
end

directory 'tmp/media'

namespace :docker do
  DOCKER_PROJECT = %w{scalpel forklift drivethrough}

  desc 'Build all the projects that can be built with docker'
  task :build do
    Bundler.with_clean_env do
      DOCKER_PROJECT.each { |project| sh "cd #{project}; #{$0} docker:build" }
    end
  end

  namespace :run do
    desc 'Run drivethrough docker image'
    task :drivethrough do
      sh 'docker run -d -P --link rabbitmq:rabbitmq boxes/drivethrough'
    end

    %w{scalpel forklift}.each do |daemon|
      desc "Run #{daemon} docker image"
      task daemon => 'tmp/media' do
        tmp_path = File.expand_path('../tmp/media', __FILE__)
        sh "docker run -d --link rabbitmq:rabbitmq -v #{tmp_path}:/var/src/media boxes/#{daemon}"
      end
    end
  end

  desc 'Run all docker images'
  task :run => %w(run:drivethrough run:scalpel run:forklift)
end
