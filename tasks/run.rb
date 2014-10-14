require 'gems'

namespace :run do
  RUNNABLE.each do |gem|
    desc "Run boxes/#{gem} container interactively"
    task gem do
      sh "docker run --rm -ti --link rabbitmq:rabbitmq boxes/#{gem}"
    end
  end

  desc 'Run servers (rabbitmq) as daemons. Old versions will be removed.'
  task :servers do
    sh 'docker rm rabbitmq'
    sh 'docker run -d -P --name rabbitmq -e RABBITMQ_USER=boxes -e RABBITMQ_PASS=boxes -p 5672:5672 -p 15672:15672 tutum/rabbitmq'
  end
end