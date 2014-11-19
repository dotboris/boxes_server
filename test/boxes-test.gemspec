# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'boxes-test'
  spec.version       = '0.0.1'
  spec.authors       = ['Boris Bera']
  spec.email         = ['bboris@rsoft.ca']
  spec.summary       = %q{Shared helpers for automated tests}
  spec.homepage      = 'https://github.com/beraboris/boxes_server'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.6'
  spec.add_dependency 'bunny', '~> 1.5'
  spec.add_dependency 'faraday', '~> 0.9'
end
