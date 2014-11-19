# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxes/version'

Gem::Specification.new do |spec|
  spec.name          = 'boxes-commons'
  spec.version       = Boxes::VERSION
  spec.authors       = ['Boris Bera']
  spec.email         = ['bboris@rsoft.ca']
  spec.summary       = %q{Common code shared by all parts of the boxes server system}

  spec.homepage      = 'https://github.com/beraboris/boxes_server'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'spec/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'fakefs', '~> 0.6'

  spec.add_dependency 'bunny', '~> 1.5'
  spec.add_dependency 'mongo_mapper', '~> 0.13.1'
end
