# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxes/admin_version'

Gem::Specification.new do |spec|
  spec.name          = 'boxes-admin'
  spec.version       = Boxes::ADMIN_VERSION
  spec.authors       = ['Boris Bera']
  spec.email         = ['bboris@rsoft.ca']
  spec.summary       = %q{Administration utilities for the Boxes server}
  spec.homepage      = 'http://github.com/beraboris/boxes_server'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'spec/**/*', 'bin/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'fakefs', '~> 0.6'

  spec.add_dependency 'boxes-commons', '1.0.0'
  spec.add_dependency 'boson', '~> 1.3'
end
