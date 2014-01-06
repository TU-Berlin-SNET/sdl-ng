# coding: utf-8
lib = File.expand_path('lib', __dir__)
$:.unshift(lib) unless $:.include?(lib)
require 'sdl/ng/version'

Gem::Specification.new do |spec|
  spec.name          = "sdl-ng"
  spec.version       = SDL::NG::VERSION
  spec.authors       = ["Mathias Slawik"]
  spec.email         = ["mathias.slawik@tu-berlin.de"]
  spec.description   = %q{Next Generation Service Description Language}
  spec.summary       = %q{Framework for building descriptions of business services.}
  spec.homepage      = 'https://github.com/TU-Berlin-SNET/sdl-ng'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '>=4.0.0'
  spec.add_runtime_dependency 'nokogiri', '1.6.0'
  spec.add_runtime_dependency 'verbs', '~> 2.1.3'
  spec.add_runtime_dependency 'linkeddata', '1.0.9'

  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'yard-redcarpet-ext'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'rspec', '2.14.1'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'simplecov', '~> 0.8.0.pre'
end