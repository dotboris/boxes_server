require 'gems'

namespace :run do
  RUNNABLE.each do |gem|
    desc "Run boxes/#{gem} container interactively"
    task gem do
      sh "docker run -t --rm --link rabbitmq:rabbitmq boxes/#{gem}"
    end
  end

  desc 'Run servers (rabbitmq) as daemons. Old versions will be removed.'
  task :servers do
    sh 'docker run -d -P --name rabbitmq -e RABBITMQ_USER=boxes -e RABBITMQ_PASS=boxes tutum/rabbitmq'
  end
end