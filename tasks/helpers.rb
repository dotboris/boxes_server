require 'pathname'

def root
  $root ||= Pathname.new(__FILE__) + '../../'
end

def version
  $boxes_version ||= (root + 'BOXES_VERSION').read.strip
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