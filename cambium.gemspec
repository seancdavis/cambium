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
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"

  [
    'kaminari',
    'paper_trail',
    'pg_search',
    'pickadate-rails',
    'rails',
    'rake',
    'superslug',
  #   'ancestry',
  #   'annotate',                     all models
  #   'backbone-on-rails',            install:app
  #   'bones-rails',
  #   'bourbon',                      install:app
  #   'coffee-rails',                 install:app
  #   'devise',                       model:user
  #   'factory_girl_rails',
  #   'faker',
  #   'hirb',
  #   'jbuilder',
  #   'jquery-rails',                 install:app
  #   'jquery-fileupload-rails',
  #   'sass-rails',                   install:app
  #   'simple_form',
  #   'uglifier',                     install:app
  #   'unicorn-rails',                install:app
  #   'wysihtml5-rails',
  ].each { |g| spec.add_dependency g }

end
