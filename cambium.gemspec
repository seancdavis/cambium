# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cambium/version'

Gem::Specification.new do |spec|
  spec.name          = "cambium"
  spec.version       = Cambium::VERSION
  spec.authors       = ["Sean C Davis", "Warren Harrison"]
  spec.email         = ["scdavis41@gmail.com", "warren@hungry-media.com"]
  spec.summary       = %q{A Ruby on Rails toolbox.}
  spec.description   = %q{Cambium is a series of utilities that work to speed up development on Ruby on Rails projects by eliminating repetitive tasks and adding useful helpers.}
  spec.homepage      = "https://github.com/seancdavis/cambium"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = Dir["spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'factory_girl_rails'

  spec.add_dependency 'rails', '>= 5.0'

end
