require 'rails'

module Cambium
  class Engine < ::Rails::Engine

    isolate_namespace Cambium

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
