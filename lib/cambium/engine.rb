require 'rails'

module Cambium
  class Engine < Rails::Engine
    config.autoload_paths += Dir["#{config.root}/lib/generators/cambium/helpers/**"]
    raise config.autoload_paths.to_yaml
  end
end
