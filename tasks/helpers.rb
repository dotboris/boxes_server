require 'pathname'
require 'boxes/version'

def root
  $root ||= Pathname.new(__FILE__) + '../../'
end

def version
  Boxes::VERSION
end

def full_name(gem)
  "boxes-#{gem}"
end

def gem_file(gem)
  "#{full_name(gem)}-#{version}.gem"
end

def pkg_gem_name(gem)
  "pkg/#{gem_file(gem)}"
end

# add a gem dependence to the docker build
#
# this will create a task for the dependency and add it as a dependency for the docker build
def add_docker_dep(gem, dep)
  target = "#{docker_dir(gem)}/#{full_name(dep)}.gem"
  file target => [docker_dir(gem), pkg_gem_name(dep)] do
    cp pkg_gem_name(dep), target
  end

  task "#{gem}:docker" => target
end

def docker_dir(gem)
  "#{gem}/docker_build"
end