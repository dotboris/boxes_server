require 'pathname'
require 'gems'

root = Pathname.new(__FILE__) + '../../'
version = (root + 'BOXES_VERSION').read.strip

directory 'pkg'

GEMS.each do |gem|
  full_name = "boxes-#{gem}"
  module_name = gem.split('_').map(&:capitalize).join
  gem_file = "pkg/#{full_name}-version.gem"
  gemspec = "#{full_name}.gemspec"

  namespace gem do
    desc "Update the version for #{full_name}"
    task :update_version do
      contents = (<<-FILE).gsub(/^\s{8}/, '')
        # WARNING: This file was generate by the #{gem}:update_version rake task. To
        # update the version exit the BOXES_VERSION file located in the project root.
        module Boxes
          module #{module_name}
            VERSION = '#{version}'
          end
        end
      FILE

      (root + gem + 'lib/boxes' + gem + 'version.rb').write(contents)
    end

    desc "Build #{gem_file}"
    task :gem => ["#{gem}:update_version", 'pkg'] do
      sh <<-CMD
        cd #{gem}
        gem build #{gemspec}
        mv #{full_name}-#{version}.gem #{root + 'pkg'}
      CMD
    end
  end
end

namespace :all do
  desc 'Update version for all projects'
  task :update_version => GEMS.map { |g| "#{g}:update_version" }

  desc 'Build all gems'
  task :gem => GEMS.map { |g| "#{g}:gem" }
end
