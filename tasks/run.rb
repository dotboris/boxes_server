require 'gems'

namespace :run do
  RUNNABLE.each do |gem|
    desc "Run boxes/#{gem} container interactively"
    task gem do
      sh "docker run -t --rm --link rabbitmq:rabbitmq boxes/#{gem}"
    end
  end
end