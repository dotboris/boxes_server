# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scalpel/version'

Gem::Specification.new do |spec|
  spec.name          = 'boxes-scalpel'
  spec.version       = Scalpel::VERSION
  spec.authors       = ['Boris Bera']
  spec.email         = ['bboris@rsoft.ca']
  spec.summary       = %q{Common code shared by all parts of the boxes server system}
  spec.description   = %q{Common code shared by all parts of the boxes server system}

  spec.homepage      = 'https://github.com/beraboris/boxes'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'spec/**/*', 'bin/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'boxes-commons', Scalpel::VERSION
  spec.add_dependency 'rmagick', '~> 2.13.2'

  spec.add_development_dependency 'fakefs', '~> 0.6.0'
end
