# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cambium/version'

Gem::Specification.new do |spec|
  spec.name          = "cambium"
  spec.version       = Cambium::VERSION
  spec.authors       = ["Sean C Davis"]
  spec.email         = ["scdavis41@gmail.com"]
  spec.summary       = %q{Rails generators to facilitate development.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_dependency "rake"
  spec.add_dependency "thor"
  
  ['unicorn-rails', 'mysql2', 'pg', 'sqlite3', 'sass-rails', 'uglifier', 
    'coffee-rails', 'jquery-rails', 'bones-rails', 'bourbon', 'rails-backbone',
    'jbuilder','simple_form', 'devise', 'carrierwave', 'hirb',
    'annotate','factory_girl_rails', 'faker',].each do |g|
    spec.add_dependency g
  end

end
