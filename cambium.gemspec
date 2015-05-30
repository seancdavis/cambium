# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cambium/version'

Gem::Specification.new do |spec|
  spec.name          = "cambium"
  spec.version       = Cambium::VERSION
  spec.authors       = ["Sean C Davis", "Warren Harrison"]
  spec.email         = ["scdavis41@gmail.com", "warren@hungry-media.com"]
  spec.summary       = %q{Rails generators to facilitate development.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"

  spec.add_dependency 'bones-rails', '>= 1.1.3'
  spec.add_dependency 'kaminari'
  spec.add_dependency 'mark_it_zero', '~> 0.3.0'
  spec.add_dependency 'paper_trail'
  spec.add_dependency 'pg_search'
  spec.add_dependency 'pickadate-rails'
  spec.add_dependency 'rails'
  spec.add_dependency 'rake'
  spec.add_dependency 'superslug'

end
