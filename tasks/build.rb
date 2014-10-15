require 'pathname'
require 'gems'
require 'helpers'

directory 'pkg'

GEMS.each do |gem|
  gemspec = "#{full_name(gem)}.gemspec"

  namespace gem do
    # gems depend on all their files
    gem_files = Dir.glob %w(bin/**/* lib/**/* spec/**/* *.gemspec).map { |p| "#{gem}/#{p}" }
    file pkg_gem_name(gem) => ['pkg'] + gem_files do
      sh <<-CMD
        cd #{gem}
        gem build #{gemspec}
        mv #{gem_file(gem)} #{root + 'pkg'}
      CMD
    end

    desc "Build #{pkg_gem_name(gem)}"
    task :gem => pkg_gem_name(gem)
  end
end

RUNNABLE.each do |gem|
  namespace gem do
    directory docker_dir(gem)

    desc "Build #{gem} docker image"
    task :docker do
      sh "docker build -t boxes/#{gem}:#{version} #{gem}"
      sh "docker tag boxes/#{gem}:#{version} boxes/#{gem}:latest"
    end

    desc "Clean #{gem} docker build dir"
    task 'docker:clean' do
      rm_rf docker_dir(gem)
    end
  end

  add_docker_dep(gem, gem)
end

add_docker_dep('scalpel', 'commons')

namespace :all do
  desc 'Build all gems'
  task :gem => GEMS.map { |g| "#{g}:gem" }

  desc 'Build all docker images'
  task :docker => RUNNABLE.map { |g| "#{g}:docker" }

  desc 'Clean all docker build dirs'
  task 'docker:clean' => RUNNABLE.map { |g| "#{g}:docker:clean" }
end
