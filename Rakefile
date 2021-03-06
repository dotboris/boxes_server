require 'bundler'

PROJECTS = %w{commons scalpel forklift gluegun drivethrough admin clerk gallery}

desc 'Run specs on projects'
task :spec do
  PROJECTS.each do |p|
    Bundler.with_clean_env { sh "cd #{p}; bundle exec #{$0}" }
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
    sh 'docker rm -v rabbitmq'
  end

  desc 'Restart rabbitmq'
  task :restart => [:stop, :start]
end

namespace :mongodb do
  desc 'Start mongodb from docker'
  task :start do
    sh 'docker run -d -P --name mongodb -p 27017:27017 mongo:2.6.5 --smallfiles'
  end

  desc 'Stop running mongodb instance'
  task :stop do
    sh 'docker stop mongodb'
    sh 'docker rm -v mongodb'
  end

  desc 'Restart mongodb'
  task :restart => [:stop, :start]
end

directory 'tmp/media'

namespace :docker do
  DOCKER_PROJECT = %w{clerk scalpel forklift drivethrough gluegun gallery}

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

    desc 'Run gluegun docker image'
    task :gluegun do
      sh 'docker run -d --link rabbitmq:rabbitmq boxes/gluegun'
    end

    desc 'Run clerk docker image'
    task :clerk do
      sh 'docker run -d --link rabbitmq:rabbitmq --link mongodb:mongodb boxes/clerk'
    end

    desc 'Run gallery docker image'
    task :gallery do
      sh 'docker run -d -P --link mongodb:mongodb boxes/gallery'
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
  task :run => %w(run:drivethrough run:scalpel run:forklift run:gluegun run:clerk run:gallery)
end
