PROJECTS = %w{commons scalpel admin}

desc 'Run specs on projects'
task :spec do
  PROJECTS.each { |p| sh "cd #{p}; #{$0} spec" }
end
task :default => 'spec'

desc 'Run bundle install on all projects'
task 'bundle:install' do
  PROJECTS.each { |p| sh "cd #{p}; bundle install"}
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
