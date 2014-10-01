# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boxes/version'

Gem::Specification.new do |spec|
  spec.name          = 'boxes'
  spec.version       = Boxes::VERSION
  spec.authors       = ['Boris Bera']
  spec.email         = ['bboris@rsoft.ca']
  spec.summary       = %q{All the daemons, tools and services used to run a boxes server}
  spec.description   = (<<-DESC).gsub(/^\s+/, '')
    Boxes is a mobile app that allows users to collaborate on drawings with strangers. This gem contains everything
    required to run the server component.
  DESC

  spec.homepage      = 'https://github.com/beraboris/boxes'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
