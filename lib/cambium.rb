require "cambium/version"

module Cambium
  require 'cambium/engine' if defined?(Rails)

  spec = Gem::Specification.find_by_name("cambium")
  gem_root = spec.gem_dir
  if defined?(Rake)
    Dir.glob("#{gem_root}/lib/helpers/**/*.rb").each { |f| require f }
  end
end
