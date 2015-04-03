require 'rails'

module Cambium
  class Engine < ::Rails::Engine
    isolate_namespace Cambium
  end
end
